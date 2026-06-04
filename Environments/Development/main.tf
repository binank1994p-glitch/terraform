# Development Environment - Module Orchestration
# Orchestrates all module deployments for Development environment
# Modules are called in dependency order
# Provider configuration inherited from root provider.tf
# Backend configuration inherited from root backend.tf

################################################################################
# Data Sources
################################################################################

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amzlinux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

################################################################################
# Foundation Modules
################################################################################

# VPC Module
module "vpc" {
  source = "../../Modules/VPC"

  # Required Arguments
  name_prefix = var.environment

  # VPC Basic Details
  vpc_name               = var.vpc_name
  vpc_cidr_block         = var.vpc_cidr_block
  vpc_availability_zones = var.vpc_availability_zones

  # VPC Subnets
  vpc_public_subnets   = var.vpc_public_subnets
  vpc_private_subnets  = var.vpc_private_subnets
  vpc_database_subnets = var.vpc_database_subnets

  # VPC Database Subnets
  vpc_create_database_subnet_group       = var.vpc_create_database_subnet_group
  vpc_create_database_subnet_route_table = var.vpc_create_database_subnet_route_table

  # VPC NAT Gateway
  vpc_enable_nat_gateway = var.vpc_enable_nat_gateway
  vpc_single_nat_gateway = var.vpc_single_nat_gateway

  # VPC Tags
  common_tags = local.common_tags
}

# EKS Module
module "eks" {
  source = "../../Modules/EKS"

  # Cluster Configuration
  cluster_name                         = var.cluster_name
  cluster_version                      = var.cluster_version
  cluster_service_ipv4_cidr            = var.cluster_service_ipv4_cidr
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  eks_oidc_root_ca_thumbprint          = var.eks_oidc_root_ca_thumbprint

  # Network Configuration
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets

  # Naming and Tags
  name_prefix = local.name
  common_tags = local.common_tags

}

# Security Groups Module
module "security_groups" {
  source = "../../Modules/SecurityGroups"

  # VPC ID from VPC Module
  vpc_id = module.vpc.vpc_id

  # Required Arguments
  vpc_cidr_block = module.vpc.vpc_cidr_block
  name_prefix    = var.environment

  # Tags
  common_tags = local.common_tags

  depends_on = [module.vpc]
}

################################################################################
# Compute Modules
################################################################################

# EC2 Bastion Module
module "ec2_bastion" {
  source = "../../Modules/EC2/Bastion"

  # Instance Configuration
  ami_id           = data.aws_ami.amzlinux2.id
  name             = "${var.environment}-bastion"
  instance_keypair = var.instance_keypair

  # VPC Configuration
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnets[0]
  subnet_id        = module.vpc.public_subnets[0]

  # Security Group
  vpc_security_group_ids = [module.security_groups.public_bastion_sg_group_id]

  # Naming and Tags
  name_prefix = local.name
  common_tags = local.common_tags

  depends_on = [module.vpc, module.security_groups]
}

# EC2 Application Module
module "ec2_application" {
  source = "../../Modules/EC2/Application"

  # Required Arguments
  app_name_prefix    = "${var.environment}-app"
  availability_zones = var.vpc_availability_zones
  ami_id             = data.aws_ami.amzlinux2.id

  # Instance Configuration
  instance_type    = var.instance_type
  instance_keypair = var.instance_keypair

  # VPC Configuration
  private_subnets = module.vpc.private_subnets

  # Security Group
  vpc_security_group_ids = [module.security_groups.private_sg_group_id]
  # User Data Scripts
  app1_user_data_script_path   = "../../Scripts/app1-install.sh"
  app2_user_data_script_path   = "../../Scripts/app2-install.sh"
  app3_user_data_template_path = "../../Scripts/app3-ums-install.tmpl"
  rds_db_endpoint              = module.rds.db_instance_address

  # Deployment Control
  deploy_pathbased_apps = true
  deploy_dnsdb_apps     = true
  deploy_app3_ums       = true

  # Instance Count
  instance_count_per_app = 2

  # Tags
  common_tags = local.common_tags

  depends_on = [module.vpc, module.security_groups]
}

# Elastic IP Module
module "eip" {
  source = "../../Modules/EIP"

  # Bastion Instance ID
  bastion_instance_id = module.ec2_bastion.bastion_instance_id

  # Tags
  common_tags = local.common_tags

  depends_on = [module.ec2_bastion]
}

################################################################################
# Certificate & DNS Modules
################################################################################

# ACM Module
module "acm" {
  source = "../../Modules/ACM"

  # Domain Configuration
  domain_name               = "myclick.agency"
  subject_alternative_names = ["*.myclick.agency"]

  # Validation Configuration
  validation_method   = "DNS"
  wait_for_validation = true

  # Tags
  common_tags = local.common_tags
}

################################################################################
# Database Module
################################################################################

# RDS Module
module "rds" {
  source = "../../Modules/RDS"

  # Database Configuration
  db_name                = var.db_name
  db_instance_identifier = var.db_instance_identifier
  db_username            = var.db_username
  db_password            = var.db_password

  # Network Configuration
  vpc_id           = module.vpc.vpc_id
  database_subnets = module.vpc.database_subnets
  vpc_cidr_block   = module.vpc.vpc_cidr_block

  # Security Group
  vpc_security_group_ids = [module.security_groups.rdsdb_sg_group_id]

  # Tags
  common_tags = local.common_tags

  depends_on = [module.vpc, module.security_groups]
}

################################################################################
# Load Balancer Modules
################################################################################

# ALB-Basic Module
module "alb_basic" {
  source = "../../Modules/ALB-Basic"

  # ALB Configuration
  alb_name = "${local.name}-alb-basic"

  # Network Configuration
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets

  # Security Group
  loadbalancer_sg_id = module.security_groups.loadbalancer_sg_group_id

  # Certificate
  certificate_arn = module.acm.acm_certificate_arn

  # Tags
  common_tags = local.common_tags

  depends_on = [module.vpc, module.security_groups, module.acm]
}

# ALB-PathBased Module
module "alb_pathbased" {
  source = "../../Modules/ALB-PathBased"

  # ALB Configuration
  alb_name = "${local.name}-alb-pathbased"

  # Network Configuration
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets

  # Security Group
  loadbalancer_sg_id = module.security_groups.loadbalancer_sg_group_id

  # Certificate
  certificate_arn = module.acm.acm_certificate_arn

  # Application Instances
  app1_instances = module.ec2_application.app1_pathbased_instance_ids
  app2_instances = module.ec2_application.app2_pathbased_instance_ids

  # Tags
  common_tags = local.common_tags

  depends_on = [module.vpc, module.security_groups, module.acm, module.ec2_application]
}

# ALB-HostHeader Module
module "alb_hostheader" {
  source = "../../Modules/ALB-HostHeader"

  # ALB Configuration
  alb_name = "${local.name}-alb-hostheader"

  # Network Configuration
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets

  # Security Group
  loadbalancer_sg_id = module.security_groups.loadbalancer_sg_group_id

  # Certificate
  certificate_arn = module.acm.acm_certificate_arn

  # Host Header Routing
  app1_dns_name = var.app1_dns_name
  app2_dns_name = var.app2_dns_name

  # Tags
  common_tags = local.common_tags

  depends_on = [module.vpc, module.security_groups, module.acm]
}

# ALB-CustomRouting Module
module "alb_customrouting" {
  source = "../../Modules/ALB-CustomRouting"

  # ALB Configuration
  alb_name = "${local.name}-alb-customrouting"

  # Network Configuration
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets

  # Security Group
  loadbalancer_sg_id = module.security_groups.loadbalancer_sg_group_id

  # Certificate
  certificate_arn = module.acm.acm_certificate_arn

  # Custom Routing Configuration
  default_dns_name  = var.default_dns_name
  redirect_dns_name = var.redirect_dns_name

  # Tags
  common_tags = local.common_tags

  depends_on = [module.vpc, module.security_groups, module.acm]
}

# ALB-DNSDB Module
module "alb_dnsdb" {
  source = "../../Modules/ALB-DNSDB"

  # ALB Configuration
  alb_name = "${local.name}-alb-dnsdb"

  # Network Configuration
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets

  # Security Group
  loadbalancer_sg_id = module.security_groups.loadbalancer_sg_group_id

  # Certificate
  certificate_arn = module.acm.acm_certificate_arn

  # DNS Configuration
  dns_to_db_name = var.dns_to_db_name

  # Tags
  common_tags = local.common_tags

  depends_on = [module.vpc, module.security_groups, module.acm, module.rds]
}

# Network Load Balancer Module
module "nlb" {
  source = "../../Modules/NLB"

  # NLB Configuration
  nlb_name_prefix = "mynlb-"

  # Network Configuration
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets

  # Security Group
  loadbalancer_sg_id = module.security_groups.loadbalancer_sg_group_id

  # Certificate
  certificate_arn = module.acm.acm_certificate_arn

  # Tags
  common_tags = local.common_tags

  depends_on = [module.vpc, module.security_groups, module.acm]
}

################################################################################
# Auto Scaling Module
################################################################################

# AutoScaling Module
module "autoscaling" {
  source = "../../Modules/AutoScaling"

  # Launch Template Configuration
  ami_id           = data.aws_ami.amzlinux2.id
  instance_type    = var.instance_type
  instance_keypair = var.instance_keypair
  private_sg_id    = module.security_groups.private_sg_group_id
  user_data_script = file("${path.module}/../../Scripts/app1-install.sh")

  # Network Configuration
  private_subnets = module.vpc.private_subnets

  # Target Groups
  target_group_arns = [module.alb_basic.alb_basic_target_groups["mytg1_basic"].arn]

  # Auto Scaling Group Configuration
  asg_name_prefix      = "myasg-"
  asg_desired_capacity = 2
  asg_max_size         = 10
  asg_min_size         = 2

  # SNS Configuration
  sns_email_endpoint = var.sns_email_endpoint

  # Tags
  common_tags = local.common_tags
  asg_tags    = local.asg_tags

  depends_on = [module.vpc, module.security_groups, module.alb_basic]
}

################################################################################
# Route53 DNS Module
################################################################################

# Route53 Module
module "route53" {
  source = "../../Modules/Route53"

  # Hosted Zone
  hosted_zone_name = "myclick.agency"

  # DNS Names
  dns_name          = var.dns_name
  app1_dns_name     = var.app1_dns_name
  app2_dns_name     = var.app2_dns_name
  default_dns_name  = var.default_dns_name
  redirect_dns_name = var.redirect_dns_name
  dns_to_db_name    = var.dns_to_db_name

  # ALB DNS and Zone IDs
  alb_pathbased_dns_name     = module.alb_pathbased.alb_pathbased_dns_name
  alb_pathbased_zone_id      = module.alb_pathbased.alb_pathbased_zone_id
  alb_hostheader_dns_name    = module.alb_hostheader.alb_hostheader_dns_name
  alb_hostheader_zone_id     = module.alb_hostheader.alb_hostheader_zone_id
  alb_customrouting_dns_name = module.alb_customrouting.alb_customrouting_dns_name
  alb_customrouting_zone_id  = module.alb_customrouting.alb_customrouting_zone_id
  alb_dnsdb_dns_name         = module.alb_dnsdb.alb_dnsdb_dns_name
  alb_dnsdb_zone_id          = module.alb_dnsdb.alb_dnsdb_zone_id
  alb_basic_dns_name         = module.alb_basic.alb_basic_dns_name
  alb_basic_zone_id          = module.alb_basic.alb_basic_zone_id
  nlb_dns_name               = module.nlb.nlb_dns_name
  nlb_zone_id                = module.nlb.nlb_zone_id

  depends_on = [
    module.alb_basic,
    module.alb_pathbased,
    module.alb_hostheader,
    module.alb_customrouting,
    module.alb_dnsdb,
    module.nlb
  ]
}

################################################################################
# Monitoring Module
################################################################################

# CloudWatch Module
module "cloudwatch" {
  source = "../../Modules/CloudWatch"

  # Auto Scaling Group Configuration
  asg_name          = module.autoscaling.autoscaling_group_name
  asg_sns_topic_arn = module.autoscaling.sns_topic_arn

  # ALB Configuration
  alb_arn_suffix = module.alb_basic.alb_basic_arn_suffix

  # Canary Configuration
  canary_zip_file = "../../Modules/CloudWatch/synthetics/sswebsite2/sswebsite2v1.zip"

  # Tags
  common_tags = local.common_tags

  depends_on = [module.autoscaling, module.alb_basic]
}


################################################################################
# Custom Modules - Refactored Resources
################################################################################

# IAM Module
module "iam" {
  source = "../../Modules/IAM"

  name_prefix    = local.name
  common_tags    = local.common_tags
  aws_account_id = data.aws_caller_identity.current.account_id
}

# K8s Resources Module
module "k8s_resources" {
  source = "../../Modules/K8s-Resources"

  depends_on = [module.eks]
}

# EKS RBAC Module
module "eks_rbac" {
  source = "../../Modules/EKS-RBAC"

  name_prefix = local.name

  # IAM Role ARNs
  eks_admin_role_arn     = module.iam.eks_admin_role_arn
  eks_developer_role_arn = module.iam.eks_developer_role_arn
  eks_readonly_role_arn  = module.iam.eks_readonly_role_arn

  # IAM User Details
  admin_user_arn  = module.iam.admin_user_arn
  admin_user_name = module.iam.admin_user_name
  basic_user_arn  = module.iam.basic_user_arn
  basic_user_name = module.iam.basic_user_name

  # Namespace
  dev_namespace_name = module.k8s_resources.dev_namespace_name

  depends_on = [module.iam, module.k8s_resources, module.eks]
}

# ALB Attachments Module
module "alb_attachments" {
  source = "../../Modules/ALB-Attachments"

  # Instance IDs
  app1_pathbased_instance_ids = module.ec2_application.app1_pathbased_instance_ids
  app2_pathbased_instance_ids = module.ec2_application.app2_pathbased_instance_ids
  app1_dnsdb_instance_ids     = module.ec2_application.app1_dnsdb_instance_ids
  app2_dnsdb_instance_ids     = module.ec2_application.app2_dnsdb_instance_ids
  app3_ums_instance_ids       = module.ec2_application.app3_ums_instance_ids

  # Target Groups
  alb_customrouting_target_groups = module.alb_customrouting.alb_customrouting_target_groups
  alb_dnsdb_target_groups         = module.alb_dnsdb.alb_dnsdb_target_groups
  alb_hostheader_target_groups    = module.alb_hostheader.alb_hostheader_target_groups

  depends_on = [
    module.alb_customrouting,
    module.alb_dnsdb,
    module.alb_hostheader,
    module.ec2_application
  ]
}


# VPC Module Output Values

# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# VPC Private Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

# VPC Public Subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# VPC Database Subnets
output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

# VPC Database Subnet Group
output "database_subnet_group" {
  description = "ID of database subnet group"
  value       = module.vpc.database_subnet_group
}

# VPC Database Subnet Group Name
output "database_subnet_group_name" {
  description = "Name of database subnet group"
  value       = module.vpc.database_subnet_group_name
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# VPC AZs
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = module.vpc.azs
}

# VPC Name
output "name" {
  description = "The name of the VPC"
  value       = module.vpc.name
}

################################################################################
# EKS Cluster Outputs
################################################################################

output "cluster_id" {
  description = "The name/id of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API"
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster"
  value       = module.eks.cluster_version
}

output "cluster_primary_security_group_id" {
  description = "The cluster primary security group ID created by the EKS cluster on 1.14 or later. Referred to as 'Cluster security group' in the EKS console"
  value       = module.eks.cluster_primary_security_group_id
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = module.eks.cluster_oidc_issuer_url
}

output "aws_iam_openid_connect_provider_arn" {
  description = "AWS IAM Open ID Connect Provider ARN"
  value       = module.eks.aws_iam_openid_connect_provider_arn
}

output "aws_iam_openid_connect_provider_extract_from_arn" {
  description = "AWS IAM Open ID Connect Provider extract from ARN"
  value       = module.eks.aws_iam_openid_connect_provider_extract_from_arn
}

output "node_group_private_id" {
  description = "Private Node Group ID"
  value       = module.eks.node_group_private_id
}

output "node_group_private_status" {
  description = "Private Node Group status"
  value       = module.eks.node_group_private_status
}

################################################################################
# ALB-HostHeader Module Outputs
################################################################################

# Load Balancer
output "alb_hostheader_id" {
  description = "The ID and ARN of the load balancer we created"
  value       = module.alb_hostheader.alb_hostheader_id
}

output "alb_hostheader_arn" {
  description = "The ARN of the load balancer we created"
  value       = module.alb_hostheader.alb_hostheader_arn
}

output "alb_hostheader_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch"
  value       = module.alb_hostheader.alb_hostheader_arn_suffix
}

output "alb_hostheader_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb_hostheader.alb_hostheader_dns_name
}

output "alb_hostheader_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = module.alb_hostheader.alb_hostheader_zone_id
}

# Listener(s)
output "alb_hostheader_listeners" {
  description = "Map of listeners created and their attributes"
  value       = module.alb_hostheader.alb_hostheader_listeners
  sensitive   = true
}

output "alb_hostheader_listener_rules" {
  description = "Map of listeners rules created and their attributes"
  value       = module.alb_hostheader.alb_hostheader_listener_rules
  sensitive   = true
}

# Target Group(s)
output "alb_hostheader_target_groups" {
  description = "Map of target groups created and their attributes"
  value       = module.alb_hostheader.alb_hostheader_target_groups
}

output "alb_hostheader_target_group_1_arn" {
  description = "ARN of target group 1 (mytg1_hostheader)"
  value       = module.alb_hostheader.alb_hostheader_target_group_1_arn
}

output "alb_hostheader_target_group_2_arn" {
  description = "ARN of target group 2 (mytg2_hostheader)"
  value       = module.alb_hostheader.alb_hostheader_target_group_2_arn
}

################################################################################
# ALB-CustomRouting Module Outputs
################################################################################

# Load Balancer
output "alb_customrouting_id" {
  description = "The ID and ARN of the load balancer"
  value       = module.alb_customrouting.alb_customrouting_id
}

output "alb_customrouting_arn" {
  description = "The ARN of the load balancer"
  value       = module.alb_customrouting.alb_customrouting_arn
}

output "alb_customrouting_arn_suffix" {
  description = "ARN suffix of the load balancer - can be used with CloudWatch"
  value       = module.alb_customrouting.alb_customrouting_arn_suffix
}

output "alb_customrouting_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb_customrouting.alb_customrouting_dns_name
}

output "alb_customrouting_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = module.alb_customrouting.alb_customrouting_zone_id
}

# Listener(s)
output "alb_customrouting_listeners" {
  description = "Map of listeners created and their attributes"
  value       = module.alb_customrouting.alb_customrouting_listeners
  sensitive   = true
}

output "alb_customrouting_listener_rules" {
  description = "Map of listener rules created and their attributes"
  value       = module.alb_customrouting.alb_customrouting_listener_rules
  sensitive   = true
}

# Target Group(s)
output "alb_customrouting_target_groups" {
  description = "Map of target groups created and their attributes"
  value       = module.alb_customrouting.alb_customrouting_target_groups
}

output "alb_customrouting_target_group_1_arn" {
  description = "ARN of target group 1 (mytg1_customrouting)"
  value       = module.alb_customrouting.alb_customrouting_target_group_1_arn
}

output "alb_customrouting_target_group_2_arn" {
  description = "ARN of target group 2 (mytg2_customrouting)"
  value       = module.alb_customrouting.alb_customrouting_target_group_2_arn
}

################################################################################
# RDS Module Outputs
################################################################################

# RDS Instance
output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.rds.db_instance_address
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.rds.db_instance_arn
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.rds.db_instance_availability_zone
}

output "db_instance_endpoint" {
  description = "The connection endpoint in address:port format"
  value       = module.rds.db_instance_endpoint
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.rds.db_instance_hosted_zone_id
}

output "db_instance_id" {
  description = "The RDS instance identifier"
  value       = module.rds.db_instance_id
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.rds.db_instance_resource_id
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = module.rds.db_instance_status
}

output "db_instance_name" {
  description = "The database name"
  value       = module.rds.db_instance_name
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = module.rds.db_instance_username
  sensitive   = true
}

output "db_instance_port" {
  description = "The database port"
  value       = module.rds.db_instance_port
}

# DB Subnet Group
output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.rds.db_subnet_group_id
}

output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.rds.db_subnet_group_arn
}

# DB Parameter Group
output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.rds.db_parameter_group_id
}

output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.rds.db_parameter_group_arn
}

# Enhanced Monitoring
output "db_enhanced_monitoring_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the monitoring role"
  value       = module.rds.db_enhanced_monitoring_iam_role_arn
}

################################################################################
# ALB-DNSDB Module Outputs
################################################################################

# Load Balancer
output "alb_dnsdb_id" {
  description = "The ID and ARN of the load balancer"
  value       = module.alb_dnsdb.alb_dnsdb_id
}

output "alb_dnsdb_arn" {
  description = "The ARN of the load balancer"
  value       = module.alb_dnsdb.alb_dnsdb_arn
}

output "alb_dnsdb_arn_suffix" {
  description = "ARN suffix of the load balancer - can be used with CloudWatch"
  value       = module.alb_dnsdb.alb_dnsdb_arn_suffix
}

output "alb_dnsdb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb_dnsdb.alb_dnsdb_dns_name
}

output "alb_dnsdb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = module.alb_dnsdb.alb_dnsdb_zone_id
}

# Listener(s)
output "alb_dnsdb_listeners" {
  description = "Map of listeners created and their attributes"
  value       = module.alb_dnsdb.alb_dnsdb_listeners
  sensitive   = true
}

output "alb_dnsdb_listener_rules" {
  description = "Map of listener rules created and their attributes"
  value       = module.alb_dnsdb.alb_dnsdb_listener_rules
  sensitive   = true
}

# Target Group(s)
output "alb_dnsdb_target_groups" {
  description = "Map of target groups created and their attributes"
  value       = module.alb_dnsdb.alb_dnsdb_target_groups
}

output "alb_dnsdb_target_group_1_arn" {
  description = "ARN of target group 1 (mytg1_dnsdb - App1)"
  value       = module.alb_dnsdb.alb_dnsdb_target_group_1_arn
}

output "alb_dnsdb_target_group_2_arn" {
  description = "ARN of target group 2 (mytg2_dnsdb - App2)"
  value       = module.alb_dnsdb.alb_dnsdb_target_group_2_arn
}

output "alb_dnsdb_target_group_3_arn" {
  description = "ARN of target group 3 (mytg3_dnsdb - App3 User Management System)"
  value       = module.alb_dnsdb.alb_dnsdb_target_group_3_arn
}

################################################################################
# ALB-Basic Module Outputs
################################################################################

output "alb_basic_id" {
  description = "The ID and ARN of the load balancer"
  value       = module.alb_basic.alb_basic_id
}

output "alb_basic_arn" {
  description = "The ARN of the load balancer"
  value       = module.alb_basic.alb_basic_arn
}

output "alb_basic_arn_suffix" {
  description = "ARN suffix of the load balancer"
  value       = module.alb_basic.alb_basic_arn_suffix
}

output "alb_basic_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb_basic.alb_basic_dns_name
}

output "alb_basic_zone_id" {
  description = "The zone_id of the load balancer"
  value       = module.alb_basic.alb_basic_zone_id
}

output "alb_basic_target_groups" {
  description = "Map of target groups"
  value       = module.alb_basic.alb_basic_target_groups
}

################################################################################
# ALB-PathBased Module Outputs
################################################################################

output "alb_pathbased_id" {
  description = "The ID and ARN of the load balancer"
  value       = module.alb_pathbased.alb_pathbased_id
}

output "alb_pathbased_arn" {
  description = "The ARN of the load balancer"
  value       = module.alb_pathbased.alb_pathbased_arn
}

output "alb_pathbased_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb_pathbased.alb_pathbased_dns_name
}

output "alb_pathbased_zone_id" {
  description = "The zone_id of the load balancer"
  value       = module.alb_pathbased.alb_pathbased_zone_id
}

################################################################################
# Route53 Module Outputs
################################################################################


output "route53_zone_id" {
  description = "Route53 Hosted Zone ID"
  value       = module.route53.route53_zone_id
}

# Security Groups Module
# Creates all security groups required for the infrastructure

# Security Group for Public Bastion Host
module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${var.name_prefix}-public-bastion-sg"
  description = "Security Group with SSH port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = var.vpc_id

  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = var.bastion_ingress_cidr_blocks

  # Egress Rule - all-all open
  egress_rules = ["all-all"]

  tags = var.common_tags
}

# Security Group for Private EC2 Instances
module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${var.name_prefix}-private-sg"
  description = "Security Group with HTTP & SSH port open for entire VPC Block (IPv4 CIDR), egress ports are all world open"
  vpc_id      = var.vpc_id

  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["ssh-tcp", "http-80-tcp", "http-8080-tcp"]
  ingress_cidr_blocks = var.private_ingress_cidr_blocks # Required for NLB health checks

  # Egress Rule - all-all open
  egress_rules = ["all-all"]

  tags = var.common_tags
}

# Security Group for Public Load Balancer
module "loadbalancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${var.name_prefix}-loadbalancer-sg"
  description = "Security Group with HTTP & HTTPS open for entire Internet (IPv4 CIDR), egress ports are all world open"
  vpc_id      = var.vpc_id

  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = var.loadbalancer_ingress_cidr_blocks

  # Egress Rule - all-all open
  egress_rules = ["all-all"]

  tags = var.common_tags
}

# Security Group for AWS RDS Database
module "rdsdb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${var.name_prefix}-rdsdb-sg"
  description = "Access to MySQL DB for entire VPC CIDR Block"
  vpc_id      = var.vpc_id

  # Ingress - MySQL/MariaDB access from within VPC
  ingress_with_cidr_blocks = [
    {
      from_port   = var.rds_db_port
      to_port     = var.rds_db_port
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = var.vpc_cidr_block
    },
  ]

  # Egress Rule - all-all open
  egress_rules = ["all-all"]

  tags = var.common_tags
}

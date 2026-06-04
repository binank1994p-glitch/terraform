# Staging Environment - Variable Values
# This file contains all variable values for the Staging environment

################################################################################
# Generic Variables
################################################################################
aws_region       = "us-east-1"
environment      = "staging"
business_divsion = "hr"

################################################################################
# VPC Variables
################################################################################
vpc_name                               = "myvpc"
vpc_cidr_block                         = "10.1.0.0/16"
vpc_availability_zones                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_public_subnets                     = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
vpc_private_subnets                    = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
vpc_database_subnets                   = ["10.1.151.0/24", "10.1.152.0/24", "10.1.153.0/24"]
vpc_create_database_subnet_group       = true
vpc_create_database_subnet_route_table = true
vpc_enable_nat_gateway                 = true
vpc_single_nat_gateway                 = true

################################################################################
# EC2 Instance Variables
################################################################################
instance_type          = "t3.small"
instance_keypair       = "terraform-key"
private_instance_count = 2

################################################################################
# DNS and Route53 Variables
################################################################################
dns_name          = "staging-alb.myclick.agency"
app1_dns_name     = "staging-app1.myclick.agency"
app2_dns_name     = "staging-app2.myclick.agency"
default_dns_name  = "staging-myapps11.myclick.agency"
redirect_dns_name = "staging-azure-aks11.myclick.agency"
dns_to_db_name    = "staging-dns-to-db.myclick.agency"

################################################################################
# RDS Database Variables
################################################################################
db_name                = "stagingwebappdb"
db_instance_identifier = "staging-webappdb"
db_username            = "dbadmin"

# WARNING: Storing passwords in plain text is not secure
# For production, use AWS Secrets Manager or environment variables
# db_password = "YourSecurePassword123!"  # Uncomment and set your password

################################################################################
# SNS Configuration Variables
################################################################################
sns_email_endpoint = "your-email@example.com" # Update with your actual email address

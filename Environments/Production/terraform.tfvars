# Production Environment - Variable Values
# This file contains all variable values for the Production environment
# Production-grade configuration with high availability

################################################################################
# Generic Variables
################################################################################
aws_region       = "us-east-1"
environment      = "prod"
business_divsion = "hr"

################################################################################
# VPC Variables - Production High Availability
################################################################################
vpc_name                               = "myvpc"
vpc_cidr_block                         = "10.2.0.0/16"
vpc_availability_zones                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_public_subnets                     = ["10.2.101.0/24", "10.2.102.0/24", "10.2.103.0/24"]
vpc_private_subnets                    = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
vpc_database_subnets                   = ["10.2.151.0/24", "10.2.152.0/24", "10.2.153.0/24"]
vpc_create_database_subnet_group       = true
vpc_create_database_subnet_route_table = true
vpc_enable_nat_gateway                 = true
vpc_single_nat_gateway                 = false # HA: NAT gateway per AZ

################################################################################
# EC2 Instance Variables - Production Grade
################################################################################
instance_type          = "t3.medium" # Production-grade instance type
instance_keypair       = "terraform-key"
private_instance_count = 3 # Higher count for production

################################################################################
# DNS and Route53 Variables
################################################################################
dns_name          = "alb.myclick.agency"
app1_dns_name     = "app1.myclick.agency"
app2_dns_name     = "app2.myclick.agency"
default_dns_name  = "myapps11.myclick.agency"
redirect_dns_name = "azure-aks11.myclick.agency"
dns_to_db_name    = "dns-to-db.myclick.agency"

################################################################################
# RDS Database Variables - Production Grade with Multi-AZ
################################################################################
db_name                = "prodwebappdb"
db_instance_identifier = "prod-webappdb"
db_username            = "dbadmin"

# WARNING: Storing passwords in plain text is not secure
# For production, use AWS Secrets Manager or environment variables
# db_password = "YourSecurePassword123!"  # Uncomment and set your password

# NOTE: The following production-grade RDS configurations should be set in the RDS module:
# - db_instance_class = "db.r5.large"  # Production-grade instance class
# - db_allocated_storage = 100         # 100 GB storage
# - db_multi_az = true                 # Enable Multi-AZ for high availability

################################################################################
# SNS Configuration Variables
################################################################################
sns_email_endpoint = "your-email@example.com" # Update with your actual email address

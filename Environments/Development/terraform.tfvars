# Development Environment - Variable Values
# This file contains all variable values for the Development environment

################################################################################
# Generic Variables
################################################################################
aws_region       = "us-east-1"
environment      = "dev"
business_divsion = "hr"

################################################################################
# VPC Variables
################################################################################
vpc_name                               = "myvpc"
vpc_cidr_block                         = "10.0.0.0/16"
vpc_availability_zones                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_public_subnets                     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
vpc_private_subnets                    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
vpc_database_subnets                   = ["10.0.151.0/24", "10.0.152.0/24", "10.0.153.0/24"]
vpc_create_database_subnet_group       = true
vpc_create_database_subnet_route_table = true
vpc_enable_nat_gateway                 = true
vpc_single_nat_gateway                 = true

################################################################################
# EKS Cluster Variables
################################################################################
cluster_name                         = "eksdemo1"
cluster_version                      = "1.34"
cluster_service_ipv4_cidr            = "172.20.0.0/16"
cluster_endpoint_private_access      = false
cluster_endpoint_public_access       = true
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
eks_oidc_root_ca_thumbprint          = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"

################################################################################
# EC2 Instance Variables
################################################################################
instance_type          = "t3.micro"
instance_keypair       = "eks-terraform-key"
private_instance_count = 2

################################################################################
# DNS and Route53 Variables
################################################################################
dns_name          = "dev-alb.myclick.agency"
app1_dns_name     = "app1.myclick.agency"
app2_dns_name     = "app2.myclick.agency"
default_dns_name  = "myapps11.myclick.agency"
redirect_dns_name = "azure-aks11.myclick.agency"
dns_to_db_name    = "dns-to-db.myclick.agency"

################################################################################
# RDS Database Variables
################################################################################
db_name                = "webappdb"
db_instance_identifier = "webappdb"
db_username            = "dbadmin"

# WARNING: Storing passwords in plain text is not secure
# For production, use AWS Secrets Manager or environment variables
db_password = "dbpassword11"

################################################################################
# SNS Configuration Variables
################################################################################
sns_email_endpoint = "amosmakokha084@gmail.com" # Update with your actual email address

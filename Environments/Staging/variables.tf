# Staging Environment - Variable Declarations
# Variable declarations without default values - values come from terraform.tfvars

################################################################################
# Generic Variables
################################################################################

variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}

variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
}

################################################################################
# VPC Variables
################################################################################

variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
}

variable "vpc_availability_zones" {
  description = "VPC Availability Zones"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = list(string)
}

variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  type        = list(string)
}

variable "vpc_create_database_subnet_group" {
  description = "VPC Create Database Subnet Group"
  type        = bool
}

variable "vpc_create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table"
  type        = bool
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateways for Private Subnets Outbound Communication"
  type        = bool
}

variable "vpc_single_nat_gateway" {
  description = "Enable only single NAT Gateway in one Availability Zone to save costs"
  type        = bool
}

################################################################################
# EC2 Instance Variables
################################################################################

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type        = string
}

variable "private_instance_count" {
  description = "AWS EC2 Private Instances Count"
  type        = number
}

################################################################################
# DNS and Route53 Variables
################################################################################

variable "dns_name" {
  description = "DNS Name for the application"
  type        = string
}

variable "app1_dns_name" {
  description = "DNS Name for App1 host-header routing"
  type        = string
}

variable "app2_dns_name" {
  description = "DNS Name for App2 host-header routing"
  type        = string
}

variable "default_dns_name" {
  description = "Default DNS Name for custom routing"
  type        = string
}

variable "redirect_dns_name" {
  description = "Redirect DNS Name for host header redirect testing"
  type        = string
}

variable "dns_to_db_name" {
  description = "DNS Name for DNS-to-DB application"
  type        = string
}

################################################################################
# RDS Database Variables
################################################################################

variable "db_name" {
  description = "AWS RDS Database Name"
  type        = string
}

variable "db_instance_identifier" {
  description = "AWS RDS Database Instance Identifier"
  type        = string
}

variable "db_username" {
  description = "AWS RDS Database Administrator Username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "AWS RDS Database Administrator Password"
  type        = string
  sensitive   = true
}

################################################################################
# SNS Configuration Variables
################################################################################

variable "sns_email_endpoint" {
  description = "Email address for SNS notifications from Auto Scaling Group"
  type        = string
}

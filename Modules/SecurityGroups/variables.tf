# SecurityGroups Module Input Variables

# VPC ID (required from VPC module)
variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

# VPC CIDR Block (required for RDS SG)
variable "vpc_cidr_block" {
  description = "VPC CIDR block for internal access rules"
  type        = string
}

# Resource Name Prefix
variable "name_prefix" {
  description = "Prefix to be used for security group naming"
  type        = string
}

# Common Tags
variable "common_tags" {
  description = "Common tags to apply to all security groups"
  type        = map(string)
  default     = {}
}

# Bastion Security Group Configuration
variable "bastion_ingress_cidr_blocks" {
  description = "CIDR blocks allowed to SSH into bastion host"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Private Security Group Configuration
variable "private_ingress_cidr_blocks" {
  description = "CIDR blocks allowed to access private instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Load Balancer Security Group Configuration
variable "loadbalancer_ingress_cidr_blocks" {
  description = "CIDR blocks allowed to access load balancer"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# RDS Database Port
variable "rds_db_port" {
  description = "Port for RDS database access"
  type        = number
  default     = 3306
}

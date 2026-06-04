# EC2 Application Module Input Variables

# Instance Configuration
variable "instance_type" {
  description = "EC2 Instance Type for application instances"
  type        = string
  default     = "t3.micro"
}

variable "instance_keypair" {
  description = "AWS EC2 Key pair that needs to be associated with application instances"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for application instances (Amazon Linux 2 recommended)"
  type        = string
}

# Networking
variable "private_subnets" {
  description = "List of private subnet IDs where application instances will be deployed"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones for the VPC"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs for application instances"
  type        = list(string)
}

# Application Configuration
variable "app_name_prefix" {
  description = "Prefix for application instance naming"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all application instances"
  type        = map(string)
  default     = {}
}

# User Data Scripts
variable "app1_user_data_script_path" {
  description = "Path to App1 user data installation script"
  type        = string
  default     = ""
}

variable "app2_user_data_script_path" {
  description = "Path to App2 user data installation script"
  type        = string
  default     = ""
}

variable "app3_user_data_template_path" {
  description = "Path to App3 UMS user data template file"
  type        = string
  default     = ""
}

# RDS Configuration (for App3 UMS only)
variable "rds_db_endpoint" {
  description = "RDS database endpoint for App3 UMS (required if deploying App3)"
  type        = string
  default     = ""
}

# Deployment Control
variable "deploy_pathbased_apps" {
  description = "Deploy pathbased routing applications (App1 and App2)"
  type        = bool
  default     = false
}

variable "deploy_dnsdb_apps" {
  description = "Deploy DNS-to-DB applications (App1, App2, App3 with RDS)"
  type        = bool
  default     = false
}

variable "deploy_app3_ums" {
  description = "Deploy App3 UMS (requires RDS and deploy_dnsdb_apps = true)"
  type        = bool
  default     = false
}

# Instance Count Configuration
variable "instance_count_per_app" {
  description = "Number of instances to create per application (for DNS-to-DB apps)"
  type        = number
  default     = 2
  validation {
    condition     = var.instance_count_per_app >= 1 && var.instance_count_per_app <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}

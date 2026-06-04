# EC2 Bastion Module Input Variables

# Instance Configuration
variable "instance_type" {
  description = "EC2 Instance Type for Bastion Host"
  type        = string
  default     = "t3.micro"
}

variable "instance_keypair" {
  description = "AWS EC2 Key pair that needs to be associated with Bastion Host"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the Bastion Host (Amazon Linux 2 recommended)"
  type        = string
}

# Networking
variable "vpc_id" {
  description = "VPC ID where Bastion Host will be deployed"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID where Bastion Host will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID where Bastion Host will be deployed"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs for Bastion Host"
  type        = list(string)
}

# Naming and Tagging
variable "name_prefix" {
  description = "Name prefix for Bastion Host resources"
  type        = string
}

variable "name" {
  description = "Name for the Bastion Host instance"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to Bastion Host"
  type        = map(string)
  default     = {}
}

# User Data Script
variable "user_data_script_path" {
  description = "Path to the user data script for Bastion Host initialization"
  type        = string
  default     = ""
}

# EIP Configuration
variable "allocate_eip" {
  description = "Whether to allocate and associate an Elastic IP with the Bastion Host"
  type        = bool
  default     = true
}

# Provisioner Configuration
variable "enable_provisioners" {
  description = "Whether to enable null resource provisioners for SSH key distribution"
  type        = bool
  default     = false
}

variable "private_key_path" {
  description = "Path to the private key file for SSH connection (required if enable_provisioners is true)"
  type        = string
  default     = ""
}

variable "ssh_user" {
  description = "SSH user for connecting to Bastion Host"
  type        = string
  default     = "ec2-user"
}

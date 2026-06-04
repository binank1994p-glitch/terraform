# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}

# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}

# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "sap"
}

# Define Local Values in Terraform
locals {
  owners      = var.business_divsion
  environment = var.environment
  name        = "${var.business_divsion}-${var.environment}"
  #name = "${local.owners}-${local.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
  asg_tags = [
    {
      key                 = "Project"
      value               = "megasecret"
      propagate_at_launch = true
    },
    {
      key                 = "foo"
      value               = ""
      propagate_at_launch = true
    },
  ]
}

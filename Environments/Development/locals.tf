# Environments/Development/locals.tf

# Data Source: AWS Caller Identity (used by IAM roles)
data "aws_caller_identity" "current" {}

# Define Local Values
locals {
  # Name prefix for all resources
  name = "${var.business_divsion}-${var.environment}"

  # Common tags to be assigned to all resources
  common_tags = {
    owners      = var.business_divsion
    environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "terraform-aws-infrastructure"
  }

  # ASG Tags (special format for Auto Scaling Groups)
  asg_tags = [
    {
      key                 = "owners"
      value               = var.business_divsion
      propagate_at_launch = true
    },
    {
      key                 = "environment"
      value               = var.environment
      propagate_at_launch = true
    },
    {
      key                 = "ManagedBy"
      value               = "Terraform"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "terraform-aws-infrastructure"
      propagate_at_launch = true
    }
  ]
}

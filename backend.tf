# Terraform Backend Configuration
# This file configures where Terraform stores its state

# By default, Terraform uses local backend (state stored in terraform.tfstate file locally)
# To switch to remote S3 backend:
# 1. Uncomment the backend "s3" block below
# 2. Update bucket and dynamodb_table names with your business_division and environment
# 3. Run: terraform init -migrate-state

# Remote State Storage with S3 Backend (COMMENTED OUT - Uncomment to enable)
/*
terraform {
  backend "s3" {
    bucket         = "terraform-state-{business_division}-{environment}-consolidated-alb"
    key            = "consolidated-alb/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-{business_division}-{environment}-consolidated-alb"
    encrypt        = true
  }
}
*/

# Example S3 Backend Configuration:
# For business_division = "hr" and environment = "stag":
#   bucket         = "terraform-state-hr-stag-consolidated-alb"
#   dynamodb_table = "terraform-lock-hr-stag-consolidated-alb"

# Terraform Block
terraform {
  required_version = ">= 1.6" # which means any version equal & above 1.6 like 1.7, 1.8 etc and < 2.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Provider Block
provider "aws" {
  region = var.aws_region
  #  profile = "default"
}
/*
Note-1:  AWS Credentials Profile (profile = "default") configured on your local desktop terminal  
$HOME/.aws/credentials
*/

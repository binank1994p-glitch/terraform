# IAM Module - Variable Declarations
# Input variables required by the IAM module

variable "name_prefix" {
  description = "Prefix for resource names (e.g., 'hr-dev')"
  type        = string
}

variable "common_tags" {
  description = "Common tags to be assigned to all resources"
  type        = map(string)
}

variable "aws_account_id" {
  description = "AWS Account ID for IAM role trust policies"
  type        = string
}

# EKS-RBAC Module - Variable Declarations
# Input variables required by the EKS RBAC module

variable "name_prefix" {
  description = "Prefix for resource names (e.g., 'hr-dev')"
  type        = string
}

variable "eks_admin_role_arn" {
  description = "ARN of EKS admin IAM role"
  type        = string
}

variable "eks_developer_role_arn" {
  description = "ARN of EKS developer IAM role"
  type        = string
}

variable "eks_readonly_role_arn" {
  description = "ARN of EKS read-only IAM role"
  type        = string
}

variable "admin_user_arn" {
  description = "ARN of admin IAM user"
  type        = string
}

variable "admin_user_name" {
  description = "Name of admin IAM user"
  type        = string
}

variable "basic_user_arn" {
  description = "ARN of basic IAM user"
  type        = string
}

variable "basic_user_name" {
  description = "Name of basic IAM user"
  type        = string
}

variable "dev_namespace_name" {
  description = "Name of the dev Kubernetes namespace"
  type        = string
}

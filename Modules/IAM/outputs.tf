# IAM Module - Output Values
# Outputs required by other modules (especially EKS RBAC module)

################################################################################
# IAM Role Outputs
################################################################################

output "eks_admin_role_arn" {
  description = "ARN of the EKS admin IAM role"
  value       = aws_iam_role.eks_admin_role.arn
}

output "eks_developer_role_arn" {
  description = "ARN of the EKS developer IAM role"
  value       = aws_iam_role.eks_developer_role.arn
}

output "eks_readonly_role_arn" {
  description = "ARN of the EKS read-only IAM role"
  value       = aws_iam_role.eks_readonly_role.arn
}

################################################################################
# IAM User Outputs
################################################################################

output "admin_user_arn" {
  description = "ARN of the admin IAM user"
  value       = aws_iam_user.admin_user.arn
}

output "admin_user_name" {
  description = "Name of the admin IAM user"
  value       = aws_iam_user.admin_user.name
}

output "basic_user_arn" {
  description = "ARN of the basic IAM user"
  value       = aws_iam_user.basic_user.arn
}

output "basic_user_name" {
  description = "Name of the basic IAM user"
  value       = aws_iam_user.basic_user.name
}

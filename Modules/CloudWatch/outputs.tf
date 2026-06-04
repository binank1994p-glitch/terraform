# Output definitions for CloudWatch module

##############################################################################
# Auto Scaling Group - Scaling Policy and Alarms
##############################################################################

output "asg_scaling_policy_arn" {
  description = "ARN of the Auto Scaling Group scaling policy for high CPU"
  value       = aws_autoscaling_policy.high_cpu.arn
}

output "asg_cpu_alarm_id" {
  description = "ID of the ASG CPU utilization CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.app1_asg_cwa_cpu.id
}

output "asg_cpu_alarm_arn" {
  description = "ARN of the ASG CPU utilization CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.app1_asg_cwa_cpu.arn
}

##############################################################################
# Application Load Balancer Alarms
##############################################################################

output "alb_4xx_alarm_id" {
  description = "ID of the ALB HTTP 4xx errors CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.alb_4xx_errors.id
}

output "alb_4xx_alarm_arn" {
  description = "ARN of the ALB HTTP 4xx errors CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.alb_4xx_errors.arn
}

##############################################################################
# CIS Benchmark Security Alarms
##############################################################################

output "cis_log_group_name" {
  description = "Name of the CloudWatch log group for CIS alarms"
  value       = aws_cloudwatch_log_group.cis_log_group.name
}

output "cis_log_group_arn" {
  description = "ARN of the CloudWatch log group for CIS alarms"
  value       = aws_cloudwatch_log_group.cis_log_group.arn
}

##############################################################################
# CloudWatch Synthetics Canary
##############################################################################

output "canary_bucket_name" {
  description = "Name of the S3 bucket for CloudWatch Synthetics artifacts"
  value       = aws_s3_bucket.cw_canary_bucket.id
}

output "canary_bucket_arn" {
  description = "ARN of the S3 bucket for CloudWatch Synthetics artifacts"
  value       = aws_s3_bucket.cw_canary_bucket.arn
}

output "canary_iam_role_arn" {
  description = "ARN of the IAM role for CloudWatch Synthetics canary"
  value       = aws_iam_role.cw_canary_iam_role.arn
}

output "canary_iam_policy_arn" {
  description = "ARN of the IAM policy for CloudWatch Synthetics canary"
  value       = aws_iam_policy.cw_canary_iam_policy.arn
}

output "canary_id" {
  description = "ID of the CloudWatch Synthetics canary"
  value       = aws_synthetics_canary.sswebsite_asg_lt.id
}

output "canary_arn" {
  description = "ARN of the CloudWatch Synthetics canary"
  value       = aws_synthetics_canary.sswebsite_asg_lt.arn
}

##############################################################################
# Synthetics Alarm
##############################################################################

output "synthetics_alarm_id" {
  description = "ID of the CloudWatch Synthetics alarm"
  value       = aws_cloudwatch_metric_alarm.synthetics_alarm_app1.id
}

output "synthetics_alarm_arn" {
  description = "ARN of the CloudWatch Synthetics alarm"
  value       = aws_cloudwatch_metric_alarm.synthetics_alarm_app1.arn
}

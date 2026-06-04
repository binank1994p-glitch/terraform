# AutoScaling Module Output Values

# ============================================================================
# LAUNCH TEMPLATE OUTPUTS
# ============================================================================

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.asg_launch_template.id
}

output "launch_template_arn" {
  description = "The ARN of the launch template"
  value       = aws_launch_template.asg_launch_template.arn
}

output "launch_template_latest_version" {
  description = "The latest version of the launch template"
  value       = aws_launch_template.asg_launch_template.latest_version
}

output "launch_template_name" {
  description = "The name of the launch template"
  value       = aws_launch_template.asg_launch_template.name
}

# ============================================================================
# AUTO SCALING GROUP OUTPUTS
# ============================================================================

output "autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = aws_autoscaling_group.asg.id
}

output "autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = aws_autoscaling_group.asg.name
}

output "autoscaling_group_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = aws_autoscaling_group.asg.arn
}

output "autoscaling_group_min_size" {
  description = "The minimum size of the autoscale group"
  value       = aws_autoscaling_group.asg.min_size
}

output "autoscaling_group_max_size" {
  description = "The maximum size of the autoscale group"
  value       = aws_autoscaling_group.asg.max_size
}

output "autoscaling_group_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = aws_autoscaling_group.asg.desired_capacity
}

output "autoscaling_group_default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity"
  value       = aws_autoscaling_group.asg.default_cooldown
}

output "autoscaling_group_health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  value       = aws_autoscaling_group.asg.health_check_grace_period
}

output "autoscaling_group_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  value       = aws_autoscaling_group.asg.health_check_type
}

output "autoscaling_group_availability_zones" {
  description = "The availability zones of the autoscale group"
  value       = aws_autoscaling_group.asg.availability_zones
}

output "autoscaling_group_vpc_zone_identifier" {
  description = "The VPC zone identifier"
  value       = aws_autoscaling_group.asg.vpc_zone_identifier
}

output "autoscaling_group_load_balancers" {
  description = "The load balancer names associated with the autoscaling group"
  value       = aws_autoscaling_group.asg.load_balancers
}

output "autoscaling_group_target_group_arns" {
  description = "List of Target Group ARNs that apply to this AutoScaling Group"
  value       = aws_autoscaling_group.asg.target_group_arns
}

# ============================================================================
# SNS OUTPUTS
# ============================================================================

output "sns_topic_arn" {
  description = "ARN of the SNS topic for autoscaling notifications"
  value       = aws_sns_topic.asg_notifications.arn
}

output "sns_topic_name" {
  description = "Name of the SNS topic"
  value       = aws_sns_topic.asg_notifications.name
}

output "sns_topic_id" {
  description = "ID of the SNS topic"
  value       = aws_sns_topic.asg_notifications.id
}

# ============================================================================
# SCALING POLICY OUTPUTS
# ============================================================================

output "ttsp_cpu_policy_name" {
  description = "Name of the CPU target tracking scaling policy"
  value       = aws_autoscaling_policy.cpu_target_tracking.name
}

output "ttsp_cpu_policy_arn" {
  description = "ARN of the CPU target tracking scaling policy"
  value       = aws_autoscaling_policy.cpu_target_tracking.arn
}

output "ttsp_cpu_policy_type" {
  description = "The scaling policy type"
  value       = aws_autoscaling_policy.cpu_target_tracking.policy_type
}

# ============================================================================
# SCHEDULED ACTION OUTPUTS
# ============================================================================

output "scheduled_action_increase_arn" {
  description = "ARN of the scheduled action for increasing capacity"
  value       = aws_autoscaling_schedule.increase_capacity.arn
}

output "scheduled_action_decrease_arn" {
  description = "ARN of the scheduled action for decreasing capacity"
  value       = aws_autoscaling_schedule.decrease_capacity.arn
}

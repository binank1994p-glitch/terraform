# AutoScaling Module Input Variables

# ============================================================================
# LAUNCH TEMPLATE CONFIGURATION
# ============================================================================

variable "ami_id" {
  description = "AMI ID for launch template instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for launch template"
  type        = string
  default     = "t3.micro"
}

variable "instance_keypair" {
  description = "Key pair name for SSH access to instances"
  type        = string
}

variable "private_sg_id" {
  description = "Private security group ID for launch template instances"
  type        = string
}

variable "user_data_script" {
  description = "User data script content (will be base64 encoded)"
  type        = string
}

variable "launch_template_name" {
  description = "Name for the launch template"
  type        = string
  default     = "my-launch-template"
}

variable "launch_template_description" {
  description = "Description for the launch template"
  type        = string
  default     = "Launch Template for Auto Scaling Group"
}

variable "ebs_optimized" {
  description = "Enable EBS optimization for instances"
  type        = bool
  default     = true
}

variable "update_default_version" {
  description = "Update default version of launch template when a new version is created"
  type        = bool
  default     = true
}

# EBS Volume Configuration
variable "root_volume_size" {
  description = "Size of root EBS volume in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Type of root EBS volume (gp2, gp3, io1, io2)"
  type        = string
  default     = "gp2"
}

variable "root_device_name" {
  description = "Device name for root volume"
  type        = string
  default     = "/dev/xvda"
}

variable "secondary_volume_size" {
  description = "Size of secondary EBS volume in GB"
  type        = number
  default     = 20
}

variable "secondary_volume_type" {
  description = "Type of secondary EBS volume (gp2, gp3, io1, io2)"
  type        = string
  default     = "gp2"
}

variable "secondary_device_name" {
  description = "Device name for secondary volume"
  type        = string
  default     = "/dev/xvdz"
}

variable "ebs_encrypted" {
  description = "Enable encryption for EBS volumes"
  type        = bool
  default     = true
}

variable "ebs_delete_on_termination" {
  description = "Delete EBS volumes on instance termination"
  type        = bool
  default     = true
}

# Monitoring and Metadata
variable "monitoring_enabled" {
  description = "Enable detailed monitoring for instances"
  type        = bool
  default     = true
}

variable "http_endpoint" {
  description = "Enable or disable the HTTP metadata endpoint"
  type        = string
  default     = "enabled"
}

variable "http_tokens" {
  description = "Whether IMDSv2 is required (optional or required)"
  type        = string
  default     = "optional"
}

variable "http_put_response_hop_limit" {
  description = "Desired HTTP PUT response hop limit for instance metadata requests"
  type        = number
  default     = 32
}

variable "lt_instance_tags" {
  description = "Map of tags for instances created by launch template"
  type        = map(string)
  default     = {}
}

# ============================================================================
# AUTO SCALING GROUP CONFIGURATION
# ============================================================================

variable "private_subnets" {
  description = "List of private subnet IDs for Auto Scaling Group"
  type        = list(string)
}

variable "target_group_arns" {
  description = "List of target group ARNs to attach to Auto Scaling Group"
  type        = list(string)
  default     = []
}

variable "asg_name_prefix" {
  description = "Prefix for Auto Scaling Group name"
  type        = string
  default     = "myasg-"
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 10
}

variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 2
}

variable "asg_health_check_type" {
  description = "Health check type for ASG (EC2 or ELB)"
  type        = string
  default     = "EC2"
}

variable "asg_health_check_grace_period" {
  description = "Time in seconds after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "asg_tags" {
  description = "List of tag maps for ASG with propagate_at_launch support"
  type = list(object({
    key                 = string
    value               = string
    propagate_at_launch = bool
  }))
  default = []
}

# ============================================================================
# LIFECYCLE HOOKS CONFIGURATION
# ============================================================================

variable "lifecycle_hook_launching_name" {
  description = "Name for instance launching lifecycle hook"
  type        = string
  default     = "ExampleStartupLifeCycleHook"
}

variable "lifecycle_hook_launching_timeout" {
  description = "Timeout in seconds for launching lifecycle hook"
  type        = number
  default     = 60
}

variable "lifecycle_hook_terminating_name" {
  description = "Name for instance terminating lifecycle hook"
  type        = string
  default     = "ExampleTerminationLifeCycleHook"
}

variable "lifecycle_hook_terminating_timeout" {
  description = "Timeout in seconds for terminating lifecycle hook"
  type        = number
  default     = 180
}

# ============================================================================
# INSTANCE REFRESH CONFIGURATION
# ============================================================================

variable "instance_refresh_strategy" {
  description = "Strategy for instance refresh (Rolling)"
  type        = string
  default     = "Rolling"
}

variable "instance_refresh_min_healthy_percentage" {
  description = "Minimum healthy percentage during instance refresh"
  type        = number
  default     = 50
}

variable "instance_refresh_triggers" {
  description = "List of instance attributes that trigger an instance refresh"
  type        = list(string)
  default     = ["desired_capacity"]
}

# ============================================================================
# SNS NOTIFICATIONS CONFIGURATION
# ============================================================================

variable "sns_email_endpoint" {
  description = "Email address for SNS notifications (required)"
  type        = string
}

# ============================================================================
# TARGET TRACKING SCALING POLICY CONFIGURATION
# ============================================================================

variable "ttsp_cpu_policy_name" {
  description = "Name for CPU target tracking scaling policy"
  type        = string
  default     = "avg-cpu-policy-greater-than-xx"
}

variable "ttsp_cpu_target_value" {
  description = "Target CPU utilization percentage for scaling"
  type        = number
  default     = 50.0
}

variable "ttsp_estimated_instance_warmup" {
  description = "Estimated time in seconds for instances to warm up"
  type        = number
  default     = 180
}

# ============================================================================
# SCHEDULED ACTIONS CONFIGURATION
# ============================================================================

# Increase Capacity Scheduled Action
variable "scheduled_action_increase_name" {
  description = "Name for scheduled action to increase capacity"
  type        = string
  default     = "increase-capacity-7am"
}

variable "scheduled_action_increase_min" {
  description = "Minimum size for increase capacity action"
  type        = number
  default     = 2
}

variable "scheduled_action_increase_max" {
  description = "Maximum size for increase capacity action"
  type        = number
  default     = 10
}

variable "scheduled_action_increase_desired" {
  description = "Desired capacity for increase capacity action"
  type        = number
  default     = 8
}

variable "scheduled_action_increase_start_time" {
  description = "Start time for increase capacity action (ISO 8601 format)"
  type        = string
  default     = "2030-03-30T11:00:00Z"
}

variable "scheduled_action_increase_recurrence" {
  description = "Cron expression for increase capacity recurrence (e.g., '00 09 * * *')"
  type        = string
  default     = "00 09 * * *"
}

# Decrease Capacity Scheduled Action
variable "scheduled_action_decrease_name" {
  description = "Name for scheduled action to decrease capacity"
  type        = string
  default     = "decrease-capacity-5pm"
}

variable "scheduled_action_decrease_min" {
  description = "Minimum size for decrease capacity action"
  type        = number
  default     = 2
}

variable "scheduled_action_decrease_max" {
  description = "Maximum size for decrease capacity action"
  type        = number
  default     = 10
}

variable "scheduled_action_decrease_desired" {
  description = "Desired capacity for decrease capacity action"
  type        = number
  default     = 2
}

variable "scheduled_action_decrease_start_time" {
  description = "Start time for decrease capacity action (ISO 8601 format)"
  type        = string
  default     = "2030-03-30T21:00:00Z"
}

variable "scheduled_action_decrease_recurrence" {
  description = "Cron expression for decrease capacity recurrence (e.g., '00 21 * * *')"
  type        = string
  default     = "00 21 * * *"
}

################################################################################
# Tags Configuration
################################################################################

variable "common_tags" {
  description = "Common tags to apply to all AutoScaling resources"
  type        = map(string)
  default     = {}
}


# Input variable definitions for CloudWatch module

##############################################################################
# Auto Scaling Group Variables
##############################################################################

variable "asg_name" {
  description = "Name of the Auto Scaling Group to monitor"
  type        = string
}

variable "asg_sns_topic_arn" {
  description = "ARN of the SNS topic for alarm notifications"
  type        = string
}

# ASG CPU Alarm Configuration
variable "high_cpu_threshold" {
  description = "CPU utilization threshold percentage for triggering scale-out"
  type        = number
  default     = 80
}

variable "high_cpu_evaluation_periods" {
  description = "Number of evaluation periods for high CPU alarm"
  type        = number
  default     = 2
}

variable "high_cpu_period" {
  description = "Period in seconds for high CPU alarm evaluation"
  type        = number
  default     = 120
}

variable "high_cpu_scaling_adjustment" {
  description = "Number of instances to add when scaling out"
  type        = number
  default     = 4
}

variable "high_cpu_cooldown" {
  description = "Cooldown period in seconds after scaling action"
  type        = number
  default     = 300
}

##############################################################################
# Application Load Balancer Variables
##############################################################################

variable "alb_arn_suffix" {
  description = "ARN suffix of the Application Load Balancer for CloudWatch metrics"
  type        = string
}

# ALB 4xx Error Alarm Configuration
variable "alb_4xx_threshold" {
  description = "Threshold for ALB HTTP 4xx errors"
  type        = number
  default     = 5
}

variable "alb_4xx_datapoints_to_alarm" {
  description = "Number of datapoints that must be breaching to trigger alarm"
  type        = number
  default     = 2
}

variable "alb_4xx_evaluation_periods" {
  description = "Number of evaluation periods for ALB 4xx alarm"
  type        = number
  default     = 3
}

variable "alb_4xx_period" {
  description = "Period in seconds for ALB 4xx alarm evaluation"
  type        = number
  default     = 120
}

##############################################################################
# CIS Alarms Configuration
##############################################################################

variable "cis_disabled_controls" {
  description = "List of CIS controls to disable"
  type        = list(string)
  default     = ["DisableOrDeleteCMK", "VPCChanges"]
}

##############################################################################
# CloudWatch Synthetics Canary Configuration
##############################################################################

variable "canary_name" {
  description = "Name of the CloudWatch Synthetics canary"
  type        = string
  default     = "sswebsite-asg-lt"
}

variable "canary_handler" {
  description = "Handler function for the canary script"
  type        = string
  default     = "sswebsite2.handler"
}

variable "canary_zip_file" {
  description = "Path to the ZIP file containing the canary script"
  type        = string
}

variable "canary_runtime_version" {
  description = "Runtime version for the canary"
  type        = string
  default     = "syn-nodejs-puppeteer-9.0"
}

variable "canary_schedule_expression" {
  description = "Schedule expression for running the canary"
  type        = string
  default     = "rate(1 minute)"
}

variable "canary_memory_in_mb" {
  description = "Memory allocation in MB for the canary"
  type        = number
  default     = 960
}

variable "canary_timeout_in_seconds" {
  description = "Timeout in seconds for the canary execution"
  type        = number
  default     = 60
}

# Synthetics Alarm Configuration
variable "canary_success_percent_threshold" {
  description = "Success percentage threshold for canary alarm"
  type        = number
  default     = 90
}

variable "canary_alarm_evaluation_periods" {
  description = "Number of evaluation periods for canary alarm"
  type        = number
  default     = 1
}

variable "canary_alarm_period" {
  description = "Period in seconds for canary alarm evaluation"
  type        = number
  default     = 300
}

##############################################################################
# Common Tags
##############################################################################

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

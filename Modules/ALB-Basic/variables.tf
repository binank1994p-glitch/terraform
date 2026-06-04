# Input variable definitions for ALB-Basic module

# ALB Configuration
variable "alb_name" {
  description = "Name for the Application Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "loadbalancer_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
}

variable "ssl_policy" {
  description = "SSL/TLS policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = false
}

# Target Group Configuration
variable "target_group_name_prefix" {
  description = "Name prefix for the target group (max 6 characters)"
  type        = string
  default     = "mtg1b-"

  validation {
    condition     = length(var.target_group_name_prefix) <= 6
    error_message = "Target group name prefix must be 6 characters or less."
  }
}

variable "target_group_port" {
  description = "Port on which targets receive traffic"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol to use for routing traffic to the targets"
  type        = string
  default     = "HTTP"
}

variable "deregistration_delay" {
  description = "Time in seconds before deregistering a target"
  type        = number
  default     = 10
}

# Health Check Configuration
variable "health_check_path" {
  description = "Path for health check requests"
  type        = string
  default     = "/app1/index.html"
}

variable "health_check_interval" {
  description = "Time in seconds between health checks"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Time in seconds for health check timeout"
  type        = number
  default     = 6
}

variable "healthy_threshold" {
  description = "Number of consecutive successful health checks before marking as healthy"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failed health checks before marking as unhealthy"
  type        = number
  default     = 3
}

# Tags
variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

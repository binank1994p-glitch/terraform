# Input variable definitions for ALB-HostHeader module

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
  default     = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = false
}

# Target Group Configuration
variable "target_group_1_name_prefix" {
  description = "Name prefix for target group 1 (max 6 characters)"
  type        = string
  default     = "mtg1h-"

  validation {
    condition     = length(var.target_group_1_name_prefix) <= 6
    error_message = "Target group name prefix must be 6 characters or less."
  }
}

variable "target_group_2_name_prefix" {
  description = "Name prefix for target group 2 (max 6 characters)"
  type        = string
  default     = "mtg2h-"

  validation {
    condition     = length(var.target_group_2_name_prefix) <= 6
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

variable "protocol_version" {
  description = "Protocol version for target groups"
  type        = string
  default     = "HTTP1"
}

variable "deregistration_delay" {
  description = "Time in seconds before deregistering a target"
  type        = number
  default     = 10
}

# Host Header Routing Configuration
variable "app1_dns_name" {
  description = "DNS name for App1 host-header based routing"
  type        = string
}

variable "app2_dns_name" {
  description = "DNS name for App2 host-header based routing"
  type        = string
}

# Health Check Configuration
variable "app1_health_check_path" {
  description = "Path for health check requests for App1 target group"
  type        = string
  default     = "/app1/index.html"
}

variable "app2_health_check_path" {
  description = "Path for health check requests for App2 target group"
  type        = string
  default     = "/app2/index.html"
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

variable "health_check_matcher" {
  description = "HTTP response codes to use when checking for a successful response"
  type        = string
  default     = "200-399"
}

# Stickiness Configuration
variable "stickiness_enabled" {
  description = "Enable session stickiness for weighted forward actions"
  type        = bool
  default     = true
}

variable "stickiness_duration" {
  description = "Duration in seconds for session stickiness"
  type        = number
  default     = 3600
}

# Fixed Response Configuration
variable "fixed_response_content_type" {
  description = "Content type for fixed response on root context"
  type        = string
  default     = "text/plain"
}

variable "fixed_response_message_body" {
  description = "Message body for fixed response on root context"
  type        = string
  default     = "Fixed Static message - for Root Context"
}

variable "fixed_response_status_code" {
  description = "Status code for fixed response on root context"
  type        = string
  default     = "200"
}

# Tags
variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

# Input variable definitions for ALB-PathBased module

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

# Routing Configuration
variable "stickiness_duration" {
  description = "Duration in seconds for session stickiness"
  type        = number
  default     = 3600
}

variable "fixed_response_message" {
  description = "Message body for fixed response on root context"
  type        = string
  default     = "Fixed Static message - for Root Context"
}

# EC2 Instance Inputs for Target Group Attachments
variable "app1_instances" {
  description = "Map of App1 EC2 instances for target group attachment (must have 'id' attribute)"
  type = map(object({
    id = string
  }))
}

variable "app2_instances" {
  description = "Map of App2 EC2 instances for target group attachment (must have 'id' attribute)"
  type = map(object({
    id = string
  }))
}

# Tags
variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

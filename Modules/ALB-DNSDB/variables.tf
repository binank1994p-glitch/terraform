# Terraform AWS Application Load Balancer (ALB) Variables - DNS-to-DB

################################################################################
# ALB Basic Configuration
################################################################################

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
  description = "Security group ID for the Application Load Balancer"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS listener"
  type        = string
}

variable "dns_to_db_name" {
  description = "DNS name for DNS-to-DB Application Load Balancer"
  type        = string
  default     = "dns-to-db.myclick.agency"
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = false
}

################################################################################
# Target Group Configuration
################################################################################

variable "target_group_1_name_prefix" {
  description = "Name prefix for target group 1 (App1)"
  type        = string
  default     = "mtg1d-"
}

variable "target_group_2_name_prefix" {
  description = "Name prefix for target group 2 (App2)"
  type        = string
  default     = "mtg2d-"
}

variable "target_group_3_name_prefix" {
  description = "Name prefix for target group 3 (App3 - User Management System)"
  type        = string
  default     = "mtg3d-"
}

variable "target_group_1_port" {
  description = "Port for target group 1 (App1)"
  type        = number
  default     = 80
}

variable "target_group_2_port" {
  description = "Port for target group 2 (App2)"
  type        = number
  default     = 80
}

variable "target_group_3_port" {
  description = "Port for target group 3 (App3 - User Management System)"
  type        = number
  default     = 8080
}

variable "target_group_protocol" {
  description = "Protocol for target groups"
  type        = string
  default     = "HTTP"
}

variable "protocol_version" {
  description = "Protocol version for target groups"
  type        = string
  default     = "HTTP1"
}

variable "deregistration_delay" {
  description = "Time in seconds for target deregistration delay"
  type        = number
  default     = 10
}

################################################################################
# Path-Based Routing Configuration
################################################################################

variable "app1_path_pattern" {
  description = "Path pattern for App1 routing"
  type        = string
  default     = "/app1*"
}

variable "app2_path_pattern" {
  description = "Path pattern for App2 routing"
  type        = string
  default     = "/app2*"
}

variable "app3_path_pattern" {
  description = "Path pattern for App3 routing (catch-all)"
  type        = string
  default     = "/*"
}

variable "app1_rule_priority" {
  description = "Priority for App1 routing rule"
  type        = number
  default     = 10
}

variable "app2_rule_priority" {
  description = "Priority for App2 routing rule"
  type        = number
  default     = 20
}

variable "app3_rule_priority" {
  description = "Priority for App3 routing rule (lowest priority)"
  type        = number
  default     = 30
}

################################################################################
# Health Check Configuration
################################################################################

variable "app1_health_check_path" {
  description = "Health check path for App1 target group"
  type        = string
  default     = "/app1/index.html"
}

variable "app2_health_check_path" {
  description = "Health check path for App2 target group"
  type        = string
  default     = "/app2/index.html"
}

variable "app3_health_check_path" {
  description = "Health check path for App3 target group (User Management System)"
  type        = string
  default     = "/login"
}

variable "health_check_interval" {
  description = "Interval between health checks in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 6
}

variable "healthy_threshold" {
  description = "Number of consecutive successful health checks before considering target healthy"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failed health checks before considering target unhealthy"
  type        = number
  default     = 3
}

variable "health_check_matcher" {
  description = "HTTP status codes to consider as healthy"
  type        = string
  default     = "200-399"
}

################################################################################
# Stickiness Configuration
################################################################################

variable "stickiness_enabled" {
  description = "Enable session stickiness for weighted forward actions"
  type        = bool
  default     = true
}

variable "stickiness_duration" {
  description = "Duration of session stickiness in seconds"
  type        = number
  default     = 3600
}

################################################################################
# Fixed Response Configuration
################################################################################

variable "fixed_response_content_type" {
  description = "Content type for fixed response"
  type        = string
  default     = "text/plain"
}

variable "fixed_response_message_body" {
  description = "Message body for fixed response"
  type        = string
  default     = "Fixed Static message - for Root Context"
}

variable "fixed_response_status_code" {
  description = "Status code for fixed response"
  type        = string
  default     = "200"
}

################################################################################
# Tags
################################################################################

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

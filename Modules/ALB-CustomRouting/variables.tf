# Terraform AWS Application Load Balancer (ALB) Variables - Custom Routing
# Variables for HTTP Header, Query String, and Host Header routing/redirects

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
  default     = "mtg1c-"
}

variable "target_group_2_name_prefix" {
  description = "Name prefix for target group 2 (App2)"
  type        = string
  default     = "mtg2c-"
}

variable "target_group_port" {
  description = "Port for target groups"
  type        = number
  default     = 80
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
# DNS Configuration
################################################################################

variable "default_dns_name" {
  description = "Default DNS name for Custom Routing ALB"
  type        = string
}

variable "redirect_dns_name" {
  description = "DNS name for Host Header Redirect testing"
  type        = string
}

################################################################################
# HTTP Header Routing Configuration (Rule 1 & 2)
################################################################################

variable "app1_http_header_name" {
  description = "HTTP header name for App1 routing"
  type        = string
  default     = "custom-header"
}

variable "app1_http_header_values" {
  description = "HTTP header values for App1 routing"
  type        = list(string)
  default     = ["app-1", "app1", "my-app-1"]
}

variable "app2_http_header_name" {
  description = "HTTP header name for App2 routing"
  type        = string
  default     = "custom-header"
}

variable "app2_http_header_values" {
  description = "HTTP header values for App2 routing"
  type        = list(string)
  default     = ["app-2", "app2", "my-app-2"]
}

################################################################################
# Query String Redirect Configuration (Rule 3)
################################################################################

variable "query_string_key" {
  description = "Query string key for redirect rule"
  type        = string
  default     = "website"
}

variable "query_string_value" {
  description = "Query string value for redirect rule"
  type        = string
  default     = "aws-eks"
}

variable "query_redirect_host" {
  description = "Host to redirect to for query string rule"
  type        = string
  default     = "stacksimplify.com"
}

variable "query_redirect_path" {
  description = "Path to redirect to for query string rule"
  type        = string
  default     = "/aws-eks/"
}

variable "query_redirect_status_code" {
  description = "HTTP status code for query string redirect"
  type        = string
  default     = "HTTP_302"
}

################################################################################
# Host Header Redirect Configuration (Rule 4)
################################################################################

variable "host_header_redirect_host" {
  description = "Host to redirect to for host header rule"
  type        = string
  default     = "stacksimplify.com"
}

variable "host_header_redirect_path" {
  description = "Path to redirect to for host header rule"
  type        = string
  default     = "/azure-aks/azure-kubernetes-service-introduction/"
}

variable "host_header_redirect_status_code" {
  description = "HTTP status code for host header redirect"
  type        = string
  default     = "HTTP_302"
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

# Input variable definitions for NLB module

# NLB Configuration
variable "nlb_name_prefix" {
  description = "Name prefix for the Network Load Balancer (max 6 characters)"
  type        = string
  default     = "mynlb-"

  validation {
    condition     = length(var.nlb_name_prefix) <= 6
    error_message = "NLB name prefix must be 6 characters or less."
  }
}

variable "vpc_id" {
  description = "VPC ID where the NLB will be created"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the NLB"
  type        = list(string)
}

variable "loadbalancer_sg_id" {
  description = "Security group ID for the NLB"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for TLS listener"
  type        = string
}

variable "dns_record_client_routing_policy" {
  description = "DNS record client routing policy for the NLB"
  type        = string
  default     = "availability_zone_affinity"

  validation {
    condition = contains([
      "availability_zone_affinity",
      "partial_availability_zone_affinity",
      "any_availability_zone"
    ], var.dns_record_client_routing_policy)
    error_message = "DNS record client routing policy must be one of: availability_zone_affinity, partial_availability_zone_affinity, any_availability_zone."
  }
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the NLB"
  type        = bool
  default     = false
}

# Listener Configuration
variable "tcp_listener_port" {
  description = "Port for the TCP listener"
  type        = number
  default     = 80
}

variable "tls_listener_port" {
  description = "Port for the TLS listener"
  type        = number
  default     = 443
}

# Target Group Configuration
variable "target_group_name_prefix" {
  description = "Name prefix for the target group (max 6 characters)"
  type        = string
  default     = "mytg1-"

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
  default     = "TCP"

  validation {
    condition     = contains(["TCP", "TLS", "UDP", "TCP_UDP"], var.target_group_protocol)
    error_message = "Target group protocol must be one of: TCP, TLS, UDP, TCP_UDP."
  }
}

variable "deregistration_delay" {
  description = "Time in seconds before deregistering a target"
  type        = number
  default     = 10
}

# Health Check Configuration
variable "health_check_enabled" {
  description = "Enable health checks for the target group"
  type        = bool
  default     = true
}

variable "health_check_path" {
  description = "Path for health check requests"
  type        = string
  default     = "/app1/index.html"
}

variable "health_check_port" {
  description = "Port for health check requests"
  type        = string
  default     = "traffic-port"
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

# Input variable definitions for Route53 module

# Route53 Hosted Zone
variable "hosted_zone_name" {
  description = "The Route53 hosted zone name (e.g., myclick.agency)"
  type        = string
}

# DNS Names for Different Routing Patterns
variable "dns_name" {
  description = "DNS Name for Path-Based ALB to support multiple environments"
  type        = string
  default     = "apps.myclick.agency"
}

variable "app1_dns_name" {
  description = "DNS Name for App1 Host-Header Based Routing"
  type        = string
}

variable "app2_dns_name" {
  description = "DNS Name for App2 Host-Header Based Routing"
  type        = string
}

variable "default_dns_name" {
  description = "Default DNS Name for Custom Routing ALB"
  type        = string
}

variable "redirect_dns_name" {
  description = "DNS Name for Host Header Redirect Testing (Custom Routing ALB)"
  type        = string
}

variable "dns_to_db_name" {
  description = "DNS Name for DNS-to-DB Application Load Balancer"
  type        = string
  default     = "dns-to-db.myclick.agency"
}

# ALB Path-Based Routing Inputs
variable "alb_pathbased_dns_name" {
  description = "DNS name of the Path-Based ALB"
  type        = string
}

variable "alb_pathbased_zone_id" {
  description = "Zone ID of the Path-Based ALB"
  type        = string
}

# ALB Host-Header Routing Inputs
variable "alb_hostheader_dns_name" {
  description = "DNS name of the Host-Header ALB"
  type        = string
}

variable "alb_hostheader_zone_id" {
  description = "Zone ID of the Host-Header ALB"
  type        = string
}

# ALB Custom Routing Inputs
variable "alb_customrouting_dns_name" {
  description = "DNS name of the Custom Routing ALB"
  type        = string
}

variable "alb_customrouting_zone_id" {
  description = "Zone ID of the Custom Routing ALB"
  type        = string
}

# ALB DNS-to-DB Inputs
variable "alb_dnsdb_dns_name" {
  description = "DNS name of the DNS-to-DB ALB"
  type        = string
}

variable "alb_dnsdb_zone_id" {
  description = "Zone ID of the DNS-to-DB ALB"
  type        = string
}

# ALB Basic Inputs (for ASG)
variable "alb_basic_dns_name" {
  description = "DNS name of the Basic ALB (used for ASG with Launch Template)"
  type        = string
}

variable "alb_basic_zone_id" {
  description = "Zone ID of the Basic ALB (used for ASG with Launch Template)"
  type        = string
}

# NLB Inputs
variable "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  type        = string
}

variable "nlb_zone_id" {
  description = "Zone ID of the Network Load Balancer"
  type        = string
}

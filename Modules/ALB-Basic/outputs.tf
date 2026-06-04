# Output definitions for ALB-Basic module

################################################################################
# Load Balancer
################################################################################

output "alb_basic_id" {
  description = "The ID and ARN of the load balancer we created"
  value       = module.alb_basic.id
}

output "alb_basic_arn" {
  description = "The ARN of the load balancer we created"
  value       = module.alb_basic.arn
}

output "alb_basic_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch"
  value       = module.alb_basic.arn_suffix
}

output "alb_basic_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb_basic.dns_name
}

output "alb_basic_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = module.alb_basic.zone_id
}

################################################################################
# Listener(s)
################################################################################

output "alb_basic_listeners" {
  description = "Map of listeners created and their attributes"
  value       = module.alb_basic.listeners
  sensitive   = true
}

output "alb_basic_listener_rules" {
  description = "Map of listeners rules created and their attributes"
  value       = module.alb_basic.listener_rules
  sensitive   = true
}

################################################################################
# Target Group(s)
################################################################################

output "alb_basic_target_groups" {
  description = "Map of target groups created and their attributes"
  value       = module.alb_basic.target_groups
}

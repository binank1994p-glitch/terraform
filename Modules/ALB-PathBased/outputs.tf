# Output definitions for ALB-PathBased module

################################################################################
# Load Balancer
################################################################################

output "alb_pathbased_id" {
  description = "The ID and ARN of the load balancer we created"
  value       = module.alb_pathbased.id
}

output "alb_pathbased_arn" {
  description = "The ARN of the load balancer we created"
  value       = module.alb_pathbased.arn
}

output "alb_pathbased_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch"
  value       = module.alb_pathbased.arn_suffix
}

output "alb_pathbased_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb_pathbased.dns_name
}

output "alb_pathbased_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = module.alb_pathbased.zone_id
}

################################################################################
# Listener(s)
################################################################################

output "alb_pathbased_listeners" {
  description = "Map of listeners created and their attributes"
  value       = module.alb_pathbased.listeners
  sensitive   = true
}

output "alb_pathbased_listener_rules" {
  description = "Map of listeners rules created and their attributes"
  value       = module.alb_pathbased.listener_rules
  sensitive   = true
}

################################################################################
# Target Group(s)
################################################################################

output "alb_pathbased_target_groups" {
  description = "Map of target groups created and their attributes"
  value       = module.alb_pathbased.target_groups
}

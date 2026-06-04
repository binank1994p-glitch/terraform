# Output definitions for ALB-HostHeader module

################################################################################
# Load Balancer
################################################################################

output "alb_hostheader_id" {
  description = "The ID and ARN of the load balancer we created"
  value       = module.alb_hostheader.id
}

output "alb_hostheader_arn" {
  description = "The ARN of the load balancer we created"
  value       = module.alb_hostheader.arn
}

output "alb_hostheader_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch"
  value       = module.alb_hostheader.arn_suffix
}

output "alb_hostheader_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb_hostheader.dns_name
}

output "alb_hostheader_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = module.alb_hostheader.zone_id
}

################################################################################
# Listener(s)
################################################################################

output "alb_hostheader_listeners" {
  description = "Map of listeners created and their attributes"
  value       = module.alb_hostheader.listeners
  sensitive   = true
}

output "alb_hostheader_listener_rules" {
  description = "Map of listeners rules created and their attributes"
  value       = module.alb_hostheader.listener_rules
  sensitive   = true
}

################################################################################
# Target Group(s)
################################################################################

output "alb_hostheader_target_groups" {
  description = "Map of target groups created and their attributes"
  value       = module.alb_hostheader.target_groups
}

output "alb_hostheader_target_group_1_arn" {
  description = "ARN of target group 1 (mytg1_hostheader)"
  value       = module.alb_hostheader.target_groups["mytg1_hostheader"].arn
}

output "alb_hostheader_target_group_2_arn" {
  description = "ARN of target group 2 (mytg2_hostheader)"
  value       = module.alb_hostheader.target_groups["mytg2_hostheader"].arn
}

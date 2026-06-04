# Terraform AWS Application Load Balancer (ALB) Outputs - Custom Routing

################################################################################
# Load Balancer Outputs
################################################################################

output "alb_customrouting_id" {
  description = "The ID and ARN of the load balancer"
  value       = module.alb_customrouting.id
}

output "alb_customrouting_arn" {
  description = "The ARN of the load balancer"
  value       = module.alb_customrouting.arn
}

output "alb_customrouting_arn_suffix" {
  description = "ARN suffix of the load balancer - can be used with CloudWatch"
  value       = module.alb_customrouting.arn_suffix
}

output "alb_customrouting_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb_customrouting.dns_name
}

output "alb_customrouting_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = module.alb_customrouting.zone_id
}

################################################################################
# Listener Outputs
################################################################################

output "alb_customrouting_listeners" {
  description = "Map of listeners created and their attributes"
  value       = module.alb_customrouting.listeners
  sensitive   = true
}

output "alb_customrouting_listener_rules" {
  description = "Map of listener rules created and their attributes"
  value       = module.alb_customrouting.listener_rules
  sensitive   = true
}

################################################################################
# Target Group Outputs
################################################################################

output "alb_customrouting_target_groups" {
  description = "Map of target groups created and their attributes"
  value       = module.alb_customrouting.target_groups
}

output "alb_customrouting_target_group_1_arn" {
  description = "ARN of target group 1 (mytg1_customrouting)"
  value       = module.alb_customrouting.target_groups["mytg1_customrouting"].arn
}

output "alb_customrouting_target_group_2_arn" {
  description = "ARN of target group 2 (mytg2_customrouting)"
  value       = module.alb_customrouting.target_groups["mytg2_customrouting"].arn
}

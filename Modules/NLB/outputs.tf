# Output definitions for NLB module

################################################################################
# Load Balancer
################################################################################

output "nlb_id" {
  description = "The ID and ARN of the load balancer we created"
  value       = module.nlb.id
}

output "nlb_arn" {
  description = "The ARN of the load balancer we created"
  value       = module.nlb.arn
}

output "nlb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch"
  value       = module.nlb.arn_suffix
}

output "nlb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.nlb.dns_name
}

output "nlb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = module.nlb.zone_id
}

################################################################################
# Listener(s)
################################################################################

output "nlb_listeners" {
  description = "Map of listeners created and their attributes"
  value       = module.nlb.listeners
}

output "nlb_listener_rules" {
  description = "Map of listeners rules created and their attributes"
  value       = module.nlb.listener_rules
}

################################################################################
# Target Group(s)
################################################################################

output "nlb_target_groups" {
  description = "Map of target groups created and their attributes"
  value       = module.nlb.target_groups
}

################################################################################
# Security Group
################################################################################

output "nlb_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the security group"
  value       = module.nlb.security_group_arn
}

output "nlb_security_group_id" {
  description = "ID of the security group"
  value       = module.nlb.security_group_id
}

################################################################################
# Route53 Record(s)
################################################################################

output "nlb_route53_records" {
  description = "The Route53 records created and attached to the load balancer"
  value       = module.nlb.route53_records
}

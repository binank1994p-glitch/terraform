# Terraform AWS Application Load Balancer (ALB) Outputs - DNS-to-DB

################################################################################
# Load Balancer Outputs
################################################################################

output "alb_dnsdb_id" {
  description = "The ID and ARN of the load balancer"
  value       = module.alb_dnsdb.id
}

output "alb_dnsdb_arn" {
  description = "The ARN of the load balancer"
  value       = module.alb_dnsdb.arn
}

output "alb_dnsdb_arn_suffix" {
  description = "ARN suffix of the load balancer - can be used with CloudWatch"
  value       = module.alb_dnsdb.arn_suffix
}

output "alb_dnsdb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb_dnsdb.dns_name
}

output "alb_dnsdb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = module.alb_dnsdb.zone_id
}

################################################################################
# Listener Outputs
################################################################################

output "alb_dnsdb_listeners" {
  description = "Map of listeners created and their attributes"
  value       = module.alb_dnsdb.listeners
  sensitive   = true
}

output "alb_dnsdb_listener_rules" {
  description = "Map of listener rules created and their attributes"
  value       = module.alb_dnsdb.listener_rules
  sensitive   = true
}

################################################################################
# Target Group Outputs
################################################################################

output "alb_dnsdb_target_groups" {
  description = "Map of target groups created and their attributes"
  value       = module.alb_dnsdb.target_groups
}

output "alb_dnsdb_target_group_1_arn" {
  description = "ARN of target group 1 (mytg1_dnsdb - App1)"
  value       = module.alb_dnsdb.target_groups["mytg1_dnsdb"].arn
}

output "alb_dnsdb_target_group_2_arn" {
  description = "ARN of target group 2 (mytg2_dnsdb - App2)"
  value       = module.alb_dnsdb.target_groups["mytg2_dnsdb"].arn
}

output "alb_dnsdb_target_group_3_arn" {
  description = "ARN of target group 3 (mytg3_dnsdb - App3 User Management System)"
  value       = module.alb_dnsdb.target_groups["mytg3_dnsdb"].arn
}

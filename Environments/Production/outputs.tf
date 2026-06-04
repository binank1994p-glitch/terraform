# Production Environment - Output Aggregation
# Aggregates outputs from deployed modules
# Outputs are available after successful module deployment

################################################################################
# VPC Outputs
################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc.natgw_ids
}

################################################################################
# Security Groups Outputs
################################################################################

output "bastion_sg_id" {
  description = "The ID of the Bastion security group"
  value       = module.security_groups.bastion_sg_id
}

output "private_sg_id" {
  description = "The ID of the Private instance security group"
  value       = module.security_groups.private_sg_id
}

output "loadbalancer_sg_id" {
  description = "The ID of the Load Balancer security group"
  value       = module.security_groups.loadbalancer_sg_id
}

output "rds_sg_id" {
  description = "The ID of the RDS security group"
  value       = module.security_groups.rdsdb_sg_id
}

################################################################################
# EC2 Bastion Outputs
################################################################################

output "bastion_instance_id" {
  description = "The ID of the Bastion instance"
  value       = module.ec2_bastion.instance_id
}

output "bastion_public_ip" {
  description = "The public IP of the Bastion instance"
  value       = module.ec2_bastion.public_ip
}

output "bastion_public_dns" {
  description = "The public DNS of the Bastion instance"
  value       = module.ec2_bastion.public_dns
}

################################################################################
# EC2 Application Outputs
################################################################################

output "application_instance_ids" {
  description = "Map of application instance IDs"
  value       = module.ec2_application.instance_ids
}

output "application_private_ips" {
  description = "Map of application instance private IPs"
  value       = module.ec2_application.private_ips
}

################################################################################
# Elastic IP Outputs
################################################################################

output "bastion_eip_id" {
  description = "The ID of the Elastic IP"
  value       = module.eip.eip_id
}

output "bastion_eip_public_ip" {
  description = "The public IP address of the Elastic IP"
  value       = module.eip.eip_public_ip
}

output "bastion_eip_public_dns" {
  description = "The public DNS associated with the Elastic IP"
  value       = module.eip.eip_public_dns
}

################################################################################
# ACM Certificate Outputs
################################################################################

output "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = module.acm.acm_certificate_arn
}

output "acm_certificate_status" {
  description = "Status of the certificate"
  value       = module.acm.acm_certificate_status
}

################################################################################
# Route53 Outputs
################################################################################

output "route53_zone_id" {
  description = "The Hosted Zone ID"
  value       = module.route53.route53_zone_id
}

output "route53_zone_name" {
  description = "The Hosted Zone name"
  value       = module.route53.route53_zone_name
}

output "apps_dns_fqdn" {
  description = "Fully Qualified Domain Name for Path-Based ALB"
  value       = module.route53.apps_dns_fqdn
}

output "app1_dns_fqdn" {
  description = "Fully Qualified Domain Name for App1"
  value       = module.route53.app1_dns_fqdn
}

output "app2_dns_fqdn" {
  description = "Fully Qualified Domain Name for App2"
  value       = module.route53.app2_dns_fqdn
}

################################################################################
# ALB-Basic Outputs
################################################################################

output "alb_basic_dns_name" {
  description = "The DNS name of the Basic ALB"
  value       = module.alb_basic.alb_basic_dns_name
}

output "alb_basic_arn" {
  description = "The ARN of the Basic ALB"
  value       = module.alb_basic.alb_basic_arn
}

output "alb_basic_zone_id" {
  description = "The zone ID of the Basic ALB"
  value       = module.alb_basic.alb_basic_zone_id
}

################################################################################
# ALB-PathBased Outputs
################################################################################

output "alb_pathbased_dns_name" {
  description = "The DNS name of the Path-Based ALB"
  value       = module.alb_pathbased.alb_pathbased_dns_name
}

output "alb_pathbased_arn" {
  description = "The ARN of the Path-Based ALB"
  value       = module.alb_pathbased.alb_pathbased_arn
}

################################################################################
# ALB-HostHeader Outputs
################################################################################

output "alb_hostheader_dns_name" {
  description = "The DNS name of the Host-Header ALB"
  value       = module.alb_hostheader.alb_hostheader_dns_name
}

output "alb_hostheader_arn" {
  description = "The ARN of the Host-Header ALB"
  value       = module.alb_hostheader.alb_hostheader_arn
}

################################################################################
# RDS Database Outputs
################################################################################

output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = module.rds.db_instance_endpoint
  sensitive   = true
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = module.rds.db_instance_id
}

output "db_instance_name" {
  description = "The database name"
  value       = module.rds.db_instance_name
}

################################################################################
# CloudWatch Outputs
################################################################################

output "asg_scaling_policy_arn" {
  description = "ARN of the Auto Scaling Group scaling policy"
  value       = module.cloudwatch.asg_scaling_policy_arn
}

output "cloudwatch_alarms" {
  description = "CloudWatch alarm IDs"
  value = {
    asg_cpu_alarm_id    = module.cloudwatch.asg_cpu_alarm_id
    alb_4xx_alarm_id    = module.cloudwatch.alb_4xx_alarm_id
    synthetics_alarm_id = module.cloudwatch.synthetics_alarm_id
  }
}

output "canary_id" {
  description = "ID of the CloudWatch Synthetics canary"
  value       = module.cloudwatch.canary_id
}

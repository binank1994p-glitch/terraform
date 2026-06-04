# EC2 Application Module Outputs

# Path-Based Routing Outputs
output "app1_pathbased_instance_ids" {
  description = "Map of App1 instance IDs for path-based routing"
  value = var.deploy_pathbased_apps ? {
    for idx, ec2 in aws_instance.app1_pathbased :
    "app1-${idx}" => {
      id                = ec2.id
      availability_zone = ec2.availability_zone
    }
  } : {}
}

output "app2_pathbased_instance_ids" {
  description = "Map of App2 instance IDs for path-based routing"
  value = var.deploy_pathbased_apps ? {
    for idx, ec2 in aws_instance.app2_pathbased :
    "app2-${idx}" => {
      id                = ec2.id
      availability_zone = ec2.availability_zone
    }
  } : {}
}


output "app1_pathbased_private_ips" {
  description = "List of App1 pathbased private IPs"
  value       = var.deploy_pathbased_apps ? [for ec2 in aws_instance.app1_pathbased : ec2.private_ip] : []
}

output "app2_pathbased_private_ips" {
  description = "List of App2 pathbased private IPs"
  value       = var.deploy_pathbased_apps ? [for ec2 in aws_instance.app2_pathbased : ec2.private_ip] : []
}

# DNS-to-DB Outputs
output "app1_dnsdb_instance_ids" {
  description = "List of App1 DNS-to-DB instance IDs"
  value       = var.deploy_dnsdb_apps ? [for ec2 in aws_instance.app1_dnsdb : ec2.id] : []
}

output "app2_dnsdb_instance_ids" {
  description = "List of App2 DNS-to-DB instance IDs"
  value       = var.deploy_dnsdb_apps ? [for ec2 in aws_instance.app2_dnsdb : ec2.id] : []
}

output "app3_ums_instance_ids" {
  description = "List of App3 UMS instance IDs"
  value       = var.deploy_app3_ums && var.deploy_dnsdb_apps ? [for ec2 in aws_instance.app3_dnsdb : ec2.id] : []
}

# SecurityGroups Module Output Values

# Public Bastion Host Security Group Outputs
output "public_bastion_sg_group_id" {
  description = "The ID of the bastion security group"
  value       = module.public_bastion_sg.security_group_id
}

output "public_bastion_sg_group_vpc_id" {
  description = "The VPC ID of the bastion security group"
  value       = module.public_bastion_sg.security_group_vpc_id
}

output "public_bastion_sg_group_name" {
  description = "The name of the bastion security group"
  value       = module.public_bastion_sg.security_group_name
}

# Private EC2 Instances Security Group Outputs
output "private_sg_group_id" {
  description = "The ID of the private security group"
  value       = module.private_sg.security_group_id
}

output "private_sg_group_vpc_id" {
  description = "The VPC ID of the private security group"
  value       = module.private_sg.security_group_vpc_id
}

output "private_sg_group_name" {
  description = "The name of the private security group"
  value       = module.private_sg.security_group_name
}

# Load Balancer Security Group Outputs
output "loadbalancer_sg_group_id" {
  description = "The ID of the load balancer security group"
  value       = module.loadbalancer_sg.security_group_id
}

output "loadbalancer_sg_group_vpc_id" {
  description = "The VPC ID of the load balancer security group"
  value       = module.loadbalancer_sg.security_group_vpc_id
}

output "loadbalancer_sg_group_name" {
  description = "The name of the load balancer security group"
  value       = module.loadbalancer_sg.security_group_name
}

# RDS Database Security Group Outputs
output "rdsdb_sg_group_id" {
  description = "The ID of the RDS database security group"
  value       = module.rdsdb_sg.security_group_id
}

output "rdsdb_sg_group_vpc_id" {
  description = "The VPC ID of the RDS database security group"
  value       = module.rdsdb_sg.security_group_vpc_id
}

output "rdsdb_sg_group_name" {
  description = "The name of the RDS database security group"
  value       = module.rdsdb_sg.security_group_name
}

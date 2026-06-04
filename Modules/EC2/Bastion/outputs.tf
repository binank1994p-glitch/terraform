# Bastion Host Outputs

# Instance Outputs
output "bastion_instance_id" {
  description = "ID of the Bastion Host instance"
  value       = aws_instance.bastion.id
}

output "bastion_instance_arn" {
  description = "ARN of the Bastion Host instance"
  value       = aws_instance.bastion.arn
}

output "bastion_availability_zone" {
  description = "Availability zone where Bastion is deployed"
  value       = aws_instance.bastion.availability_zone
}

# IP and DNS Outputs
output "bastion_public_ip" {
  description = "Public IP address of Bastion (from instance)"
  value       = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  description = "Private IP address of Bastion"
  value       = aws_instance.bastion.private_ip
}

output "bastion_public_dns" {
  description = "Public DNS name of Bastion"
  value       = aws_instance.bastion.public_dns
}

output "bastion_private_dns" {
  description = "Private DNS name of Bastion"
  value       = aws_instance.bastion.private_dns
}

# Elastic IP Outputs
output "bastion_eip_id" {
  description = "ID of the Elastic IP"
  value       = var.allocate_eip ? aws_eip.bastion_eip_original[0].id : null
}

output "bastion_eip_public_ip" {
  description = "Elastic IP address"
  value       = var.allocate_eip ? aws_eip.bastion_eip_original[0].public_ip : null
}

output "bastion_eip_allocation_id" {
  description = "Allocation ID of the Elastic IP"
  value       = var.allocate_eip ? aws_eip.bastion_eip_original[0].allocation_id : null
}

# Security Group Outputs
output "bastion_security_groups" {
  description = "List of security group IDs attached to Bastion"
  value       = aws_instance.bastion.vpc_security_group_ids
}

output "bastion_security_group_id" {
  description = "Security Group ID of the Bastion Host"
  value       = module.public_bastion_sg.security_group_id
}

# Connection Output
output "bastion_ssh_command" {
  description = "SSH command to connect to Bastion"
  value       = var.allocate_eip ? "ssh -i ${var.instance_keypair}.pem ${var.ssh_user}@${aws_eip.bastion_eip_original[0].public_ip}" : "ssh -i ${var.instance_keypair}.pem ${var.ssh_user}@${aws_instance.bastion.public_ip}"
}

# Public EC2 Instances - Bastion Host

## ec2_bastion_public_instance_ids
output "ec2_bastion_public_instance_ids" {
  description = "List of IDs of instances"
  value       = aws_instance.bastion.id
}

## ec2_bastion_public_ip
output "ec2_bastion_public_ip" {
  description = "Elastic IP associated to the Bastion Host"
  value       = var.allocate_eip ? aws_eip.bastion_eip_original[0].public_ip : aws_instance.bastion.public_ip
}

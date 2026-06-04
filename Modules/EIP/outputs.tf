# Output definitions for EIP module

output "eip_id" {
  description = "The ID of the Elastic IP"
  value       = aws_eip.bastion_eip.id
}

output "eip_public_ip" {
  description = "The public IP address of the Elastic IP"
  value       = aws_eip.bastion_eip.public_ip
}

output "eip_public_dns" {
  description = "The public DNS associated with the Elastic IP"
  value       = aws_eip.bastion_eip.public_dns
}

output "eip_allocation_id" {
  description = "The allocation ID of the Elastic IP"
  value       = aws_eip.bastion_eip.allocation_id
}

output "eip_association_id" {
  description = "The association ID of the Elastic IP"
  value       = aws_eip.bastion_eip.association_id
}

output "eip_instance_id" {
  description = "The ID of the instance associated with the Elastic IP"
  value       = aws_eip.bastion_eip.instance
}

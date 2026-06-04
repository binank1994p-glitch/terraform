# Input variable definitions for EIP module

variable "bastion_instance_id" {
  description = "The ID of the bastion EC2 instance to associate the EIP with"
  type        = string
}

variable "common_tags" {
  description = "Common tags to be applied to the Elastic IP resource"
  type        = map(string)
  default     = {}
}

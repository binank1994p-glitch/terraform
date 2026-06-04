# Create Elastic IP for Bastion Host
# Resource - depends_on Meta-Argument
resource "aws_eip" "bastion_eip" {
  instance = var.bastion_instance_id
  domain   = "vpc"
  tags     = var.common_tags

  ## Local Exec Provisioner: local-exec provisioner (Destroy-Time Provisioner - Triggered during deletion of Resource)
  provisioner "local-exec" {
    command     = "echo Destroy time prov `date` >> destroy-time-prov.txt"
    working_dir = "local-exec-output-files/"
    when        = destroy
    #on_failure = continue
  }
}

# EC2 Bastion Module
# Creates a Bastion/Jumpbox host in a public subnet with optional EIP and provisioners

# Get latest AMI ID for Amazon Linux2 OS
data "aws_ami" "amzlinux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# AWS EC2 Security Group Terraform Module
# Security Group for Public Bastion Host
module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${var.name_prefix}-public-bastion-sg"
  description = "Security Group with SSH port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = var.vpc_id
  
  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = var.common_tags
}

# EC2 Instance - Bastion Host (Direct Resource)
resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = var.user_data_script_path != "" ? file(var.user_data_script_path) : null
  
  tags = merge(
    var.common_tags,
    {
      Name = var.name
    }
  )
}

# Elastic IP (for direct aws_instance.bastion)
resource "aws_eip" "bastion_eip_original" {
  count      = var.allocate_eip ? 1 : 0
  depends_on = [aws_instance.bastion]
  instance   = aws_instance.bastion.id
  domain     = "vpc"
  
  tags = merge(
    var.common_tags,
    {
      Name = "${var.name}-eip"
    }
  )
}

# Null Resource for Bastion Host Provisioners
resource "null_resource" "bastion_provisioner" {
  count      = var.enable_provisioners && var.private_key_path != "" ? 1 : 0
  depends_on = [aws_instance.bastion, aws_eip.bastion_eip_original]
  
  # Connection Block for Provisioners
  connection {
    type        = "ssh"
    host        = var.allocate_eip ? aws_eip.bastion_eip_original[0].public_ip : aws_instance.bastion.public_ip
    user        = var.ssh_user
    private_key = file(var.private_key_path)
  }

  # File Provisioner: Copy the private key to bastion
  provisioner "file" {
    source      = var.private_key_path
    destination = "/tmp/terraform-key.pem"
  }

  # Remote Exec Provisioner: Fix private key permissions
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/terraform-key.pem"
    ]
  }
  
  # Local Exec Provisioner: Log VPC creation
  provisioner "local-exec" {
    command     = "echo Bastion created on `date` and VPC ID: ${var.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-files/"
    on_failure  = continue
  }
}

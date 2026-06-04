# EC2 Bastion Module

## Overview
This module creates a Bastion Host (also known as a Jump Box) in a public subnet. The Bastion Host provides secure SSH access to instances in private subnets, serving as a gateway for administrative access to your infrastructure.

## Features
- EC2 instance deployed in public subnet
- Optional Elastic IP allocation and association
- Optional null resource provisioners for SSH key distribution
- User data script support for initialization
- Configurable instance type and AMI
- Security group integration
- Comprehensive outputs including SSH connection commands

## Architecture
```
Internet
    │
    ├─── Elastic IP (optional)
    │
    └─── Bastion Host (Public Subnet)
             │
             └─── SSH to Private Instances
```

## Usage

### Basic Example (Minimal Configuration)
```hcl
module "bastion" {
  source = "../../Modules/EC2/Bastion"

  # Instance Configuration
  name              = "myapp-dev-bastion"
  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = "t3.micro"
  instance_keypair  = "my-keypair"

  # Networking
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.security_groups.public_bastion_sg_group_id]

  # Elastic IP
  allocate_eip = true

  # Tags
  common_tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

### Advanced Example (With Provisioners and User Data)
```hcl
# Data source for Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

module "bastion" {
  source = "../../Modules/EC2/Bastion"

  # Instance Configuration
  name              = "myapp-prod-bastion"
  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = "t3.small"
  instance_keypair  = "production-keypair"

  # Networking
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.security_groups.public_bastion_sg_group_id]

  # User Data
  user_data_script_path = "${path.module}/scripts/jumpbox-install.sh"

  # Elastic IP
  allocate_eip = true

  # Provisioners (for SSH key distribution)
  enable_provisioners = true
  private_key_path    = "private-key/production-keypair.pem"
  ssh_user            = "ec2-user"

  # Tags
  common_tags = {
    Environment = "production"
    Project     = "myapp"
    Role        = "bastion"
  }
}

# Output SSH command
output "bastion_connection" {
  description = "Command to SSH into bastion"
  value       = module.bastion.bastion_ssh_command
}
```

### Production Example (High Security)
```hcl
module "bastion" {
  source = "../../Modules/EC2/Bastion"

  name              = "myapp-prod-bastion"
  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = "t3.medium"
  instance_keypair  = "prod-bastion-key"

  subnet_id = module.vpc.public_subnets[0]
  
  # Use restrictive security group (SSH from corporate IP only)
  vpc_security_group_ids = [module.security_groups.public_bastion_sg_group_id]

  allocate_eip        = true
  enable_provisioners = false  # Disable for production (use AWS Systems Manager instead)

  common_tags = {
    Environment = "production"
    Project     = "myapp"
    Compliance  = "required"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instance_type | EC2 Instance Type for Bastion Host | `string` | `"t3.micro"` | no |
| instance_keypair | AWS EC2 Key pair name | `string` | n/a | yes |
| ami_id | AMI ID for the Bastion Host | `string` | n/a | yes |
| subnet_id | Public subnet ID where Bastion will be deployed | `string` | n/a | yes |
| vpc_security_group_ids | List of security group IDs | `list(string)` | n/a | yes |
| name | Name for the Bastion Host instance | `string` | n/a | yes |
| common_tags | Common tags to apply | `map(string)` | `{}` | no |
| user_data_script_path | Path to user data script | `string` | `""` | no |
| allocate_eip | Allocate and associate Elastic IP | `bool` | `true` | no |
| enable_provisioners | Enable null resource provisioners | `bool` | `false` | no |
| private_key_path | Path to private key file (for provisioners) | `string` | `""` | no |
| ssh_user | SSH user for connecting | `string` | `"ec2-user"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion_instance_id | ID of the Bastion Host instance |
| bastion_instance_arn | ARN of the Bastion Host instance |
| bastion_availability_zone | Availability zone where Bastion is deployed |
| bastion_public_ip | Public IP address (from instance) |
| bastion_private_ip | Private IP address |
| bastion_public_dns | Public DNS name |
| bastion_private_dns | Private DNS name |
| bastion_eip_id | ID of the Elastic IP |
| bastion_eip_public_ip | Elastic IP address |
| bastion_eip_allocation_id | Allocation ID of the Elastic IP |
| bastion_security_groups | List of security group IDs |
| bastion_ssh_command | SSH command to connect to Bastion |

## Security Best Practices

### Recommended Configuration
1. **Use Elastic IP**: Set `allocate_eip = true` for stable connection endpoint
2. **Restrict SSH Access**: Configure security group to allow SSH only from known IPs
3. **Use Strong Key Pairs**: Generate and use strong RSA keys (minimum 2048-bit)
4. **Disable Root Login**: Configure SSH to disable root login
5. **Enable CloudWatch Logs**: Monitor bastion access logs
6. **Session Manager**: Consider using AWS Systems Manager Session Manager instead of SSH

### Provisioners
- **Development**: Enable provisioners for convenience (`enable_provisioners = true`)
- **Production**: Disable provisioners (`enable_provisioners = false`) and use AWS Systems Manager Session Manager
- Provisioners copy private keys to bastion - ensure keys are properly secured

### User Data Script Example
```bash
#!/bin/bash
# jumpbox-install.sh
yum update -y
yum install -y htop vim tmux
echo "Bastion host initialized on $(date)" > /var/log/bastion-init.log
```

## Connection Workflow
```
Developer → Bastion (Public IP/EIP) → Private Instance
         SSH (port 22)              SSH (port 22)
```

### Connecting Through Bastion
```bash
# Step 1: SSH to Bastion
ssh -i my-keypair.pem ec2-user@<bastion-eip>

# Step 2: From Bastion, SSH to Private Instance
ssh -i /tmp/terraform-key.pem ec2-user@<private-instance-ip>
```

### SSH Tunneling (Port Forwarding)
```bash
# Forward port 3306 from private RDS instance through bastion
ssh -i my-keypair.pem -L 3306:<rds-endpoint>:3306 ec2-user@<bastion-eip>
```

## Maintenance and Monitoring

### Regular Updates
```bash
# SSH into bastion
ssh -i keypair.pem ec2-user@<bastion-eip>

# Update packages
sudo yum update -y
```

### Monitoring
- Enable CloudWatch monitoring
- Set up CloudWatch alarms for:
  - CPU utilization
  - Network In/Out
  - Status checks
  - SSH login attempts (via logs)

## Dependencies
This module depends on:
- VPC module (for subnet_id)
- SecurityGroups module (for vpc_security_group_ids)

Uses the official AWS EC2 instance module:
- Source: `terraform-aws-modules/ec2-instance/aws`
- Version: `5.6.1`

## References
- [AWS Bastion Host Best Practices](https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/create-a-bastion-host-to-access-a-private-amazon-rds-db-instance.html)
- [Terraform AWS EC2 Instance Module](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)
- [AWS Systems Manager Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html)

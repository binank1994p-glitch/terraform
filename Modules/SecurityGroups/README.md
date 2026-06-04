# SecurityGroups Terraform Module

## Overview
This module creates all security groups required for a complete AWS infrastructure, including security groups for bastion hosts, private application instances, load balancers, and RDS databases.

## Features
- **Bastion Security Group**: SSH access for bastion/jumpbox hosts
- **Private Security Group**: HTTP/SSH access for private application instances
- **Load Balancer Security Group**: HTTP/HTTPS access for Application/Network Load Balancers
- **RDS Database Security Group**: MySQL/MariaDB access restricted to VPC CIDR

## Security Groups Created

### 1. Public Bastion Security Group
- **Purpose**: SSH access to bastion/jumpbox hosts
- **Ingress**: SSH (port 22) from configurable CIDR blocks
- **Egress**: All traffic allowed

### 2. Private Security Group
- **Purpose**: Access control for private application instances
- **Ingress**: SSH (22), HTTP (80), HTTP (8080) from configurable CIDR blocks
- **Egress**: All traffic allowed
- **Note**: 0.0.0.0/0 required for NLB health checks

### 3. Load Balancer Security Group
- **Purpose**: Internet-facing load balancer access
- **Ingress**: HTTP (80), HTTPS (443) from internet
- **Egress**: All traffic allowed

### 4. RDS Database Security Group
- **Purpose**: Database access restricted to VPC
- **Ingress**: MySQL (3306) from VPC CIDR only
- **Egress**: All traffic allowed

## Usage

### Basic Example
```hcl
module "security_groups" {
  source = "../../Modules/SecurityGroups"

  # VPC Configuration
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block

  # Naming
  name_prefix = "myapp-dev"

  # Tags
  common_tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

### Production Example (Restricted Access)
```hcl
module "security_groups" {
  source = "../../Modules/SecurityGroups"

  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  name_prefix    = "myapp-prod"

  # Restrict bastion SSH access to corporate network only
  bastion_ingress_cidr_blocks = ["203.0.113.0/24"]

  # Private instances accessible from VPC only
  private_ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

  # Load balancer open to internet
  loadbalancer_ingress_cidr_blocks = ["0.0.0.0/0"]

  # Custom RDS port
  rds_db_port = 3306

  common_tags = {
    Environment = "production"
    Project     = "myapp"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | VPC ID where security groups will be created | `string` | n/a | yes |
| vpc_cidr_block | VPC CIDR block for internal access rules | `string` | n/a | yes |
| name_prefix | Prefix for security group naming | `string` | n/a | yes |
| common_tags | Common tags to apply to all security groups | `map(string)` | `{}` | no |
| bastion_ingress_cidr_blocks | CIDR blocks allowed to SSH into bastion | `list(string)` | `["0.0.0.0/0"]` | no |
| private_ingress_cidr_blocks | CIDR blocks allowed to access private instances | `list(string)` | `["0.0.0.0/0"]` | no |
| loadbalancer_ingress_cidr_blocks | CIDR blocks allowed to access load balancer | `list(string)` | `["0.0.0.0/0"]` | no |
| rds_db_port | Port for RDS database access | `number` | `3306` | no |

## Outputs

| Name | Description |
|------|-------------|
| public_bastion_sg_group_id | ID of the bastion security group |
| public_bastion_sg_group_vpc_id | VPC ID of the bastion security group |
| public_bastion_sg_group_name | Name of the bastion security group |
| private_sg_group_id | ID of the private security group |
| private_sg_group_vpc_id | VPC ID of the private security group |
| private_sg_group_name | Name of the private security group |
| loadbalancer_sg_group_id | ID of the load balancer security group |
| loadbalancer_sg_group_vpc_id | VPC ID of the load balancer security group |
| loadbalancer_sg_group_name | Name of the load balancer security group |
| rdsdb_sg_group_id | ID of the RDS database security group |
| rdsdb_sg_group_vpc_id | VPC ID of the RDS database security group |
| rdsdb_sg_group_name | Name of the RDS database security group |

## Security Best Practices

### Development Environment
- Bastion: Restrict to office/VPN IP ranges
- Private: Keep as 0.0.0.0/0 for NLB health checks (required)
- Load Balancer: Open to internet (0.0.0.0/0)
- RDS: Always restricted to VPC CIDR

### Production Environment
- Bastion: **MUST** restrict to known IP ranges (corporate network, VPN)
- Private: 0.0.0.0/0 required for NLB, but consider additional SG rules for specific source SGs
- Load Balancer: 0.0.0.0/0 or CloudFront IP ranges if using CloudFront
- RDS: Always restricted to VPC CIDR only

### Important Notes
1. **NLB Health Checks**: Private SG requires 0.0.0.0/0 because NLB health checks come from AWS IP ranges
2. **RDS Access**: Database SG uses VPC CIDR to allow access from any instance within the VPC
3. **Security Groups are Stateful**: Return traffic is automatically allowed
4. **Least Privilege**: Always restrict bastion access to known IPs in production

## Dependencies
This module uses the official AWS Security Group module:
- Source: `terraform-aws-modules/security-group/aws`
- Version: `5.1.0`

## References
- [AWS Security Groups Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)
- [Terraform AWS Security Group Module](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
- [AWS Security Best Practices](https://docs.aws.amazon.com/security/latest/userguide/best-practices.html)

# VPC Terraform Module

## Overview
This module creates a complete AWS VPC infrastructure using the official Terraform AWS VPC module. It provides a 3-tier architecture with public, private, and database subnets across multiple availability zones.

## Features
- VPC with custom CIDR block
- Public subnets for internet-facing resources
- Private subnets for application servers
- Database subnets with subnet group
- Internet Gateway for public subnet internet access
- NAT Gateways for private subnet outbound connectivity
- Configurable single or multiple NAT Gateways (cost optimization)
- DNS hostname and DNS support enabled
- Comprehensive tagging strategy

## Architecture
```
VPC (10.0.0.0/16)
├── Public Subnets (10.0.101.0/24, 10.0.102.0/24)
│   └── Internet Gateway
├── Private Subnets (10.0.1.0/24, 10.0.2.0/24)
│   └── NAT Gateway(s)
└── Database Subnets (10.0.151.0/24, 10.0.152.0/24)
    └── DB Subnet Group
```

## Usage

### Basic Example
```hcl
module "vpc" {
  source = "../../Modules/VPC"

  # Naming
  name_prefix = "myapp-dev"
  vpc_name    = "main"

  # CIDR Configuration
  vpc_cidr_block         = "10.0.0.0/16"
  vpc_availability_zones = ["us-east-1a", "us-east-1b"]

  # Subnet Configuration
  vpc_public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"]
  vpc_private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  vpc_database_subnets = ["10.0.151.0/24", "10.0.152.0/24"]

  # NAT Gateway Configuration
  vpc_enable_nat_gateway = true
  vpc_single_nat_gateway = true  # Set to false for HA (one NAT per AZ)

  # Tags
  common_tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

### Production Example (High Availability)
```hcl
module "vpc" {
  source = "../../Modules/VPC"

  name_prefix            = "myapp-prod"
  vpc_name               = "main"
  vpc_cidr_block         = "10.0.0.0/16"
  vpc_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  vpc_public_subnets   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  vpc_private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  vpc_database_subnets = ["10.0.151.0/24", "10.0.152.0/24", "10.0.153.0/24"]

  vpc_enable_nat_gateway = true
  vpc_single_nat_gateway = false  # Multiple NAT Gateways for HA

  common_tags = {
    Environment = "production"
    Project     = "myapp"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_name | VPC Name | `string` | n/a | yes |
| vpc_cidr_block | VPC CIDR Block | `string` | n/a | yes |
| vpc_availability_zones | VPC Availability Zones | `list(string)` | n/a | yes |
| vpc_public_subnets | VPC Public Subnets | `list(string)` | n/a | yes |
| vpc_private_subnets | VPC Private Subnets | `list(string)` | n/a | yes |
| vpc_database_subnets | VPC Database Subnets | `list(string)` | n/a | yes |
| vpc_create_database_subnet_group | Create Database Subnet Group | `bool` | `true` | no |
| vpc_create_database_subnet_route_table | Create Database Subnet Route Table | `bool` | `true` | no |
| vpc_enable_nat_gateway | Enable NAT Gateways | `bool` | n/a | yes |
| vpc_single_nat_gateway | Use single NAT Gateway (cost optimization) | `bool` | n/a | yes |
| common_tags | Common tags to apply to all resources | `map(string)` | `{}` | no |
| name_prefix | Prefix for resource naming | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| private_subnets | List of IDs of private subnets |
| public_subnets | List of IDs of public subnets |
| database_subnets | List of IDs of database subnets |
| database_subnet_group | ID of database subnet group |
| database_subnet_group_name | Name of database subnet group |
| nat_public_ips | List of public Elastic IPs created for AWS NAT Gateway |
| azs | A list of availability zones specified as argument to this module |
| name | The name of the VPC |

## Notes

### NAT Gateway Cost Optimization
- **Development/Testing**: Set `vpc_single_nat_gateway = true` to use a single NAT Gateway
- **Production**: Set `vpc_single_nat_gateway = false` to create one NAT Gateway per AZ for high availability

### Subnet Sizing
Ensure your subnet CIDR blocks:
- Don't overlap
- Are within the VPC CIDR range
- Are appropriately sized for your needs (consider future growth)
- Follow the pattern: public (101-102), private (1-2), database (151-152)

### Dependencies
This module uses the official AWS VPC module:
- Source: `terraform-aws-modules/vpc/aws`
- Version: `5.4.0`

## References
- [Terraform AWS VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [AWS NAT Gateway Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html)

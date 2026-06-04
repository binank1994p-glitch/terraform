# EC2 Application Module

## Overview
This module creates private application EC2 instances with support for multiple deployment patterns:
- **Path-Based Routing**: Instances with automatic availability zone instance type validation
- **DNS-to-DB**: Simple multi-instance deployment patterns
- **UMS (User Management System)**: RDS-integrated application with templated user data

## Features
- Multiple application deployment patterns (pathbased, DNS-to-DB, UMS)
- Automatic instance type availability validation per AZ
- Flexible instance count configuration
- Support for user data scripts and templates
- RDS integration for App3 UMS
- Conditional deployment flags for different app types
- Comprehensive outputs for load balancer integration

## Architecture

### Path-Based Routing Pattern
```
Private Subnet 1    Private Subnet 2
    │                   │
    ├─ App1-Instance    ├─ App1-Instance
    │                   │
    └─ App2-Instance    └─ App2-Instance
```

### DNS-to-DB Pattern
```
Private Subnet 1    Private Subnet 2
    │                   │
    ├─ App1-DNSDB       ├─ App1-DNSDB
    ├─ App2-DNSDB       ├─ App2-DNSDB
    └─ App3-UMS ───────────► RDS Database
```

## Usage

### Basic Example (Path-Based Routing Only)
```hcl
module "application_instances" {
  source = "../../Modules/EC2/Application"

  # Instance Configuration
  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = "t3.micro"
  instance_keypair  = "my-keypair"
  app_name_prefix   = "myapp-dev"

  # Networking
  private_subnets        = module.vpc.private_subnets
  availability_zones     = module.vpc.azs
  vpc_security_group_ids = [module.security_groups.private_sg_group_id]

  # Deployment Control
  deploy_pathbased_apps = true
  deploy_dnsdb_apps     = false

  # User Data Scripts
  app1_user_data_script_path = "${path.module}/scripts/app1-install.sh"
  app2_user_data_script_path = "${path.module}/scripts/app2-install.sh"

  # Tags
  common_tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

### Advanced Example (All Applications with RDS)
```hcl
# Data source for AMI
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

module "application_instances" {
  source = "../../Modules/EC2/Application"

  # Instance Configuration
  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = "t3.small"
  instance_keypair  = "production-keypair"
  app_name_prefix   = "myapp-prod"

  # Networking
  private_subnets        = module.vpc.private_subnets
  availability_zones     = module.vpc.azs
  vpc_security_group_ids = [module.security_groups.private_sg_group_id]

  # Deployment Control - Deploy all applications
  deploy_pathbased_apps = true
  deploy_dnsdb_apps     = true
  deploy_app3_ums       = true

  # Instance Count (for DNS-to-DB apps)
  instance_count_per_app = 2

  # User Data Configuration
  app1_user_data_script_path   = "${path.module}/scripts/app1-install.sh"
  app2_user_data_script_path   = "${path.module}/scripts/app2-install.sh"
  app3_user_data_template_path = "${path.module}/scripts/app3-ums-install.tmpl"

  # RDS Configuration (for App3 UMS)
  rds_db_endpoint = module.rds.db_instance_address

  # Tags
  common_tags = {
    Environment = "production"
    Project     = "myapp"
  }
}
```

### Selective Deployment Example
```hcl
# Deploy only DNS-to-DB applications (without UMS)
module "application_instances" {
  source = "../../Modules/EC2/Application"

  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = "t3.micro"
  instance_keypair  = "staging-keypair"
  app_name_prefix   = "myapp-staging"

  private_subnets        = module.vpc.private_subnets
  availability_zones     = module.vpc.azs
  vpc_security_group_ids = [module.security_groups.private_sg_group_id]

  # Deploy only DNS-to-DB apps (App1 and App2), skip UMS
  deploy_pathbased_apps = false
  deploy_dnsdb_apps     = true
  deploy_app3_ums       = false  # No RDS required

  instance_count_per_app = 3  # 3 instances per app

  app1_user_data_script_path = "${path.module}/scripts/app1-install.sh"
  app2_user_data_script_path = "${path.module}/scripts/app2-install.sh"

  common_tags = {
    Environment = "staging"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instance_type | EC2 Instance Type | `string` | `"t3.micro"` | no |
| instance_keypair | AWS EC2 Key pair name | `string` | n/a | yes |
| ami_id | AMI ID for application instances | `string` | n/a | yes |
| private_subnets | List of private subnet IDs | `list(string)` | n/a | yes |
| availability_zones | List of availability zones | `list(string)` | n/a | yes |
| vpc_security_group_ids | List of security group IDs | `list(string)` | n/a | yes |
| app_name_prefix | Prefix for instance naming | `string` | n/a | yes |
| common_tags | Common tags | `map(string)` | `{}` | no |
| app1_user_data_script_path | Path to App1 script | `string` | `""` | no |
| app2_user_data_script_path | Path to App2 script | `string` | `""` | no |
| app3_user_data_template_path | Path to App3 template | `string` | `""` | no |
| rds_db_endpoint | RDS endpoint for App3 | `string` | `""` | no |
| deploy_pathbased_apps | Deploy pathbased apps | `bool` | `false` | no |
| deploy_dnsdb_apps | Deploy DNS-to-DB apps | `bool` | `false` | no |
| deploy_app3_ums | Deploy App3 UMS | `bool` | `false` | no |
| instance_count_per_app | Instances per app (DNS-to-DB) | `number` | `2` | no |

## Outputs

### Path-Based Routing Outputs
| Name | Description |
|------|-------------|
| ec2_app1_pathbased_instance_ids | App1 pathbased instance IDs |
| ec2_app1_pathbased_private_ips | App1 pathbased private IPs |
| ec2_app2_pathbased_instance_ids | App2 pathbased instance IDs |
| ec2_app2_pathbased_private_ips | App2 pathbased private IPs |

### DNS-to-DB Outputs
| Name | Description |
|------|-------------|
| ec2_app1_dnsdb_instance_ids | App1 DNS-to-DB instance IDs |
| ec2_app1_dnsdb_private_ips | App1 DNS-to-DB private IPs |
| ec2_app2_dnsdb_instance_ids | App2 DNS-to-DB instance IDs |
| ec2_app2_dnsdb_private_ips | App2 DNS-to-DB private IPs |
| ec2_app3_ums_instance_ids | App3 UMS instance IDs |
| ec2_app3_ums_private_ips | App3 UMS private IPs |

### Utility Outputs
| Name | Description |
|------|-------------|
| supported_azs_for_instance_type | AZs supporting the instance type |
| instance_type | Instance type used |

## Application Patterns Explained

### 1. Path-Based Routing
- Instances are created only in AZs that support the specified instance type
- Uses complex `for_each` logic with AZ validation
- Ideal for ALB path-based routing (e.g., `/app1/*`, `/app2/*`)
- Automatically distributes instances across validated AZs

### 2. DNS-to-DB Applications
- Simple `for_each` pattern: `toset(["0", "1", ...])`
- Fixed instance count across subnets
- No AZ instance type validation (assumes type is available)
- Used for host-header routing or custom routing patterns

### 3. App3 UMS (User Management System)
- RDS-integrated application
- Uses `templatefile()` to inject RDS endpoint into user data
- Requires both `deploy_dnsdb_apps = true` and `deploy_app3_ums = true`
- Template receives `rds_db_endpoint` variable

## User Data Scripts

### App1/App2 Install Script Example
```bash
#!/bin/bash
# app1-install.sh
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>App1 - $(hostname)</h1>" > /var/www/html/index.html
```

### App3 UMS Template Example
```bash
#!/bin/bash
# app3-ums-install.tmpl
yum update -y
yum install -y httpd php php-mysql
systemctl start httpd
systemctl enable httpd

# Configure database connection
cat > /var/www/html/dbconfig.php <<EOF
<?php
\$db_host = "${rds_db_endpoint}";
\$db_name = "webappdb";
\$db_user = "admin";
?>
EOF
```

## Instance Type Validation

The module includes automatic instance type availability checking:
```hcl
# Data source checks which AZs support the instance type
data "aws_ec2_instance_type_offerings" "instance_type_by_az" {
  for_each = toset(data.aws_availability_zones.available.names)
  
  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }
}
```

This ensures pathbased instances are only created in AZs where the instance type is available, preventing deployment failures.

## Dependencies
- VPC module (for private_subnets and availability_zones)
- SecurityGroups module (for vpc_security_group_ids)
- RDS module (optional, for App3 UMS rds_db_endpoint)

Uses the official AWS EC2 instance module:
- Source: `terraform-aws-modules/ec2-instance/aws`
- Version: `5.6.1`

## References
- [Terraform AWS EC2 Instance Module](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)
- [AWS EC2 Instance Types](https://aws.amazon.com/ec2/instance-types/)
- [EC2 User Data Scripts](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)

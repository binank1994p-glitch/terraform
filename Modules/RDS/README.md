# RDS Module - Corrected Version

## Overview

This module creates an AWS RDS MySQL database instance using the Terraform AWS RDS community module. It's designed to receive security groups externally from the SecurityGroups module, maintaining consistency with other infrastructure modules.

## Key Changes from Original

### ✅ What Was Fixed

1. **Added Missing Variable** - `vpc_security_group_ids`
   - Location: `variables.tf` lines 227-232
   - Purpose: Accept external security group IDs from SecurityGroups module

2. **Removed Internal Security Group Creation**
   - Removed: `module "rdsdb_sg"` block from `main.tf` (lines 14-37 in original)
   - Reason: Security groups are managed centrally by SecurityGroups module

3. **Removed Unused Variables**
   - Removed: `rdsdb_sg_name` and `rdsdb_sg_description`
   - Reason: No longer creating internal security group

4. **Removed Unused Outputs**
   - Removed: `rdsdb_sg_id` and `rdsdb_sg_arn` 
   - Reason: Security group is created externally

### 📋 Design Pattern

This module follows the established pattern where:
- SecurityGroups module creates ALL security groups
- Application modules (EC2, RDS, etc.) receive security groups as inputs
- Maintains separation of concerns and centralized security management

## Module Files

```
Modules/RDS/
├── main.tf         # RDS instance creation using terraform-aws-modules/rds/aws
├── variables.tf    # Input variable definitions
├── outputs.tf      # RDS instance outputs
└── README.md       # This file
```

## Usage

### In Development Environment

```hcl
module "rds" {
  source = "../../Modules/RDS"

  # Database Configuration
  db_name                = var.db_name
  db_instance_identifier = var.db_instance_identifier
  db_username            = var.db_username
  db_password            = var.db_password

  # Network Configuration
  vpc_id           = module.vpc.vpc_id
  database_subnets = module.vpc.database_subnets
  vpc_cidr_block   = module.vpc.vpc_cidr_block

  # Security Group (from SecurityGroups module)
  vpc_security_group_ids = [module.security_groups.rdsdb_sg_id]

  # Tags
  common_tags = local.common_tags

  depends_on = [module.vpc, module.security_groups]
}
```

## Required Inputs

| Name | Description | Type |
|------|-------------|------|
| `vpc_id` | VPC ID where RDS will be created | `string` |
| `database_subnets` | List of database subnet IDs | `list(string)` |
| `vpc_cidr_block` | VPC CIDR block (for documentation) | `string` |
| `db_password` | Master password for the database | `string` (sensitive) |
| `vpc_security_group_ids` | List of security group IDs | `list(string)` |

## Optional Inputs

All other variables have sensible defaults. See `variables.tf` for complete list.

### Key Defaults:
- **Engine:** MySQL 8.0.40
- **Instance Class:** db.t3.large
- **Multi-AZ:** true
- **Allocated Storage:** 20 GB (auto-scaling up to 100 GB)
- **Backup Retention:** 0 days (disabled for dev)
- **Performance Insights:** Enabled
- **Enhanced Monitoring:** Enabled (60 second interval)

## Outputs

### Primary Outputs:
- `db_instance_endpoint` - Connection endpoint (host:port)
- `db_instance_address` - Database host address
- `db_instance_port` - Database port (default 3306)
- `db_instance_id` - RDS instance identifier
- `db_instance_arn` - RDS instance ARN

### Additional Outputs:
- Subnet group details
- Parameter group details
- Monitoring role ARN
- Instance status and metadata

See `outputs.tf` for complete list.

## Dependencies

### Terraform Modules Used:
- `terraform-aws-modules/rds/aws` version 6.3.0

### Required Modules (from your infrastructure):
- VPC module - Provides database subnets
- SecurityGroups module - Provides RDS security group

## Features

✅ Multi-AZ deployment for high availability
✅ Automated backups (configurable retention)
✅ Performance Insights enabled
✅ Enhanced CloudWatch monitoring
✅ UTF-8 (utf8mb4) character set configuration
✅ Encryption support (configurable)
✅ Auto-scaling storage (20-100 GB)
✅ Deletion protection (configurable)
✅ CloudWatch log exports

## Security

- Security group is managed externally by SecurityGroups module
- Password is marked as sensitive
- Username is marked as sensitive
- Supports encryption at rest
- Supports deletion protection
- Uses VPC database subnets (private subnets)

## Notes

### For Development Environment:
- Backup retention is set to 0 (no backups)
- Skip final snapshot is enabled
- Deletion protection is disabled

### For Production Environment:
Consider changing these values:
```hcl
db_backup_retention_period = 7  # or more
db_skip_final_snapshot     = false
db_deletion_protection     = true
db_storage_encrypted       = true
db_instance_class          = "db.r5.large"  # or larger
```

## Validation

After applying the module:

```bash
# Check RDS instance
aws rds describe-db-instances --db-instance-identifier <your-identifier>

# Test connection (from bastion or app instance)
mysql -h <db-endpoint> -u <username> -p
```

## Migration from Original

If you had the original version with internal security group:

1. The security group is now created in SecurityGroups module
2. Update your environment's main.tf to pass the SG ID
3. Remove any references to `rdsdb_sg_name` and `rdsdb_sg_description` from tfvars
4. The module outputs `rdsdb_sg_id` and `rdsdb_sg_arn` are no longer available

## Version History

- **v1.1** (Current) - Removed internal SG, added vpc_security_group_ids variable
- **v1.0** - Original version with internal security group creation

## Author

Terraform AWS Infrastructure Project
Module: RDS Database

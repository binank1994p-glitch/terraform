# Terraform AWS RDS Database Module
# This module creates a MySQL 8.0 RDS database instance with:
# - Multi-AZ deployment for high availability
# - Automated backups with configurable retention
# - Performance Insights for monitoring
# - Enhanced monitoring with CloudWatch
# - Database subnet group in VPC database subnets
# - Security group provided externally from SecurityGroups module

################################################################################
# RDS Database Instance
################################################################################

module "rdsdb" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.3.0"

  # Database Instance Identifier
  identifier = var.db_instance_identifier

  # Database Configuration
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  # Password Management
  manage_master_user_password = false

  # Engine Configuration
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  family               = var.db_family
  major_engine_version = var.db_major_engine_version
  instance_class       = var.db_instance_class

  # Storage Configuration
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_encrypted     = var.db_storage_encrypted

  # High Availability Configuration
  multi_az = var.db_multi_az

  # Network Configuration
  create_db_subnet_group = true
  subnet_ids             = var.database_subnets
  vpc_security_group_ids = var.vpc_security_group_ids

  # Maintenance and Backup Configuration
  maintenance_window      = var.db_maintenance_window
  backup_window           = var.db_backup_window
  backup_retention_period = var.db_backup_retention_period

  # CloudWatch Logs
  enabled_cloudwatch_logs_exports = var.db_enabled_cloudwatch_logs_exports

  # Snapshot Configuration
  skip_final_snapshot = var.db_skip_final_snapshot
  deletion_protection = var.db_deletion_protection

  # Performance Insights
  performance_insights_enabled          = var.db_performance_insights_enabled
  performance_insights_retention_period = var.db_performance_insights_retention_period

  # Enhanced Monitoring
  create_monitoring_role = var.db_create_monitoring_role
  monitoring_interval    = var.db_monitoring_interval
  monitoring_role_name   = var.db_monitoring_role_name

  # Database Parameters - UTF-8 Character Set Configuration
  parameters = [
    {
      name  = "character_set_client"
      value = var.db_character_set_client
    },
    {
      name  = "character_set_server"
      value = var.db_character_set_server
    }
  ]

  # Tags
  tags                    = var.common_tags
  db_instance_tags        = var.db_instance_tags
  db_option_group_tags    = var.db_option_group_tags
  db_parameter_group_tags = var.db_parameter_group_tags
  db_subnet_group_tags    = var.db_subnet_group_tags
}

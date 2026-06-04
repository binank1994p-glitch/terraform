# Terraform AWS RDS Database Variables

################################################################################
# VPC Configuration (from VPC Module)
################################################################################

variable "vpc_id" {
  description = "VPC ID where the RDS instance will be created"
  type        = string
}

variable "database_subnets" {
  description = "List of database subnet IDs for RDS DB subnet group"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block for security group ingress rules"
  type        = string
}

################################################################################
# Database Configuration
################################################################################

variable "db_name" {
  description = "Name of the database to create"
  type        = string
  default     = "webappdb"
}

variable "db_instance_identifier" {
  description = "Identifier for the RDS instance"
  type        = string
  default     = "webappdb"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  sensitive   = true
  default     = "dbadmin"
}

variable "db_password" {
  description = "Master password for the database (required, no default)"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Port on which the database accepts connections"
  type        = number
  default     = 3306
}

################################################################################
# Engine Configuration
################################################################################

variable "db_engine" {
  description = "Database engine type"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0.40"
}

variable "db_family" {
  description = "Database family for parameter group"
  type        = string
  default     = "mysql8.0"
}

variable "db_major_engine_version" {
  description = "Major version of the database engine"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.t3.large"
}

################################################################################
# Storage Configuration
################################################################################

variable "db_allocated_storage" {
  description = "Allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum allocated storage for autoscaling in gigabytes"
  type        = number
  default     = 100
}

variable "db_storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = false
}

################################################################################
# High Availability Configuration
################################################################################

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment for high availability"
  type        = bool
  default     = true
}

################################################################################
# Maintenance and Backup Configuration
################################################################################

variable "db_maintenance_window" {
  description = "Preferred maintenance window (UTC)"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "db_backup_window" {
  description = "Preferred backup window (UTC)"
  type        = string
  default     = "03:00-06:00"
}

variable "db_backup_retention_period" {
  description = "Number of days to retain backups (0 to disable)"
  type        = number
  default     = 0
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot when deleting the database"
  type        = bool
  default     = true
}

variable "db_deletion_protection" {
  description = "Enable deletion protection for the database"
  type        = bool
  default     = false
}

################################################################################
# CloudWatch Logs Configuration
################################################################################

variable "db_enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default     = ["general"]
}

################################################################################
# Performance Insights Configuration
################################################################################

variable "db_performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
  default     = true
}

variable "db_performance_insights_retention_period" {
  description = "Performance Insights retention period in days"
  type        = number
  default     = 7
}

################################################################################
# Enhanced Monitoring Configuration
################################################################################

variable "db_create_monitoring_role" {
  description = "Create IAM role for enhanced monitoring"
  type        = bool
  default     = true
}

variable "db_monitoring_interval" {
  description = "Enhanced monitoring interval in seconds (0 to disable)"
  type        = number
  default     = 60
}

variable "db_monitoring_role_name" {
  description = "Name of the IAM role for enhanced monitoring"
  type        = string
  default     = "rds-monitoring-role-webappdb"
}

################################################################################
# Database Parameters Configuration
################################################################################

variable "db_character_set_client" {
  description = "Character set for client connections"
  type        = string
  default     = "utf8mb4"
}

variable "db_character_set_server" {
  description = "Character set for the server"
  type        = string
  default     = "utf8mb4"
}

################################################################################
# Security Group Configuration (External)
################################################################################

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs to associate with the RDS instance"
  type        = list(string)
}

################################################################################
# Tags Configuration
################################################################################

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "db_instance_tags" {
  description = "Additional tags for the DB instance"
  type        = map(string)
  default = {
    "Sensitive" = "high"
  }
}

variable "db_option_group_tags" {
  description = "Additional tags for the DB option group"
  type        = map(string)
  default = {
    "Sensitive" = "low"
  }
}

variable "db_parameter_group_tags" {
  description = "Additional tags for the DB parameter group"
  type        = map(string)
  default = {
    "Sensitive" = "low"
  }
}

variable "db_subnet_group_tags" {
  description = "Additional tags for the DB subnet group"
  type        = map(string)
  default = {
    "Sensitive" = "high"
  }
}

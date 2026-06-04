# EC2 Application Module
# Creates private application instances for various routing patterns

# ============================================================================
# DATA SOURCES
# ============================================================================

# Data source: Check which AZs support the specified instance type
data "aws_ec2_instance_type_offerings" "instance_type_by_az" {
  for_each = toset(var.availability_zones)

  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }

  filter {
    name   = "location"
    values = [each.key]
  }

  location_type = "availability-zone"
}

# ============================================================================
# PATH-BASED ROUTING APPLICATIONS
# ============================================================================

# App1 - Path-Based Routing
resource "aws_instance" "app1_pathbased" {
  for_each = var.deploy_pathbased_apps ? toset([
    for idx, az in var.availability_zones : tostring(idx)
  ]) : toset([])

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  subnet_id              = element(var.private_subnets, tonumber(each.key))
  vpc_security_group_ids = var.vpc_security_group_ids

  # User data script
  user_data = var.app1_user_data_script_path != "" ? file(var.app1_user_data_script_path) : null

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name_prefix}-app1-pathbased-${each.key}"
    }
  )
}

# App2 - Path-Based Routing
resource "aws_instance" "app2_pathbased" {
  for_each = var.deploy_pathbased_apps ? toset([
    for idx, az in var.availability_zones : tostring(idx)
  ]) : toset([])

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  subnet_id              = element(var.private_subnets, tonumber(each.key))
  vpc_security_group_ids = var.vpc_security_group_ids

  # User data script
  user_data = var.app2_user_data_script_path != "" ? file(var.app2_user_data_script_path) : null

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name_prefix}-app2-pathbased-${each.key}"
    }
  )
}

# ============================================================================
# DNS-TO-DB APPLICATIONS
# ============================================================================

# App1 - DNS-to-DB
# Simple deployment across specified number of instances
resource "aws_instance" "app1_dnsdb" {
  # For_each: Create instances only if deploy_dnsdb_apps is true
  for_each = var.deploy_dnsdb_apps ? toset([for i in range(var.instance_count_per_app) : tostring(i)]) : toset([])

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  subnet_id              = element(var.private_subnets, tonumber(each.key))
  vpc_security_group_ids = var.vpc_security_group_ids

  # User data script
  user_data = var.app1_user_data_script_path != "" ? file(var.app1_user_data_script_path) : null

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name_prefix}-app1-dnsdb-${each.key}"
    }
  )
}

# App2 - DNS-to-DB
# Simple deployment across specified number of instances
resource "aws_instance" "app2_dnsdb" {
  # For_each: Create instances only if deploy_dnsdb_apps is true
  for_each = var.deploy_dnsdb_apps ? toset([for i in range(var.instance_count_per_app) : tostring(i)]) : toset([])

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  subnet_id              = element(var.private_subnets, tonumber(each.key))
  vpc_security_group_ids = var.vpc_security_group_ids

  # User data script
  user_data = var.app2_user_data_script_path != "" ? file(var.app2_user_data_script_path) : null

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name_prefix}-app2-dnsdb-${each.key}"
    }
  )
}

# App3 - UMS (User Management System) with RDS Database
# Requires RDS endpoint and uses template file for user data
resource "aws_instance" "app3_dnsdb" {
  # For_each: Create instances only if both deploy_app3_ums AND deploy_dnsdb_apps are true
  for_each = var.deploy_app3_ums && var.deploy_dnsdb_apps ? toset([for i in range(var.instance_count_per_app) : tostring(i)]) : toset([])

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  subnet_id              = element(var.private_subnets, tonumber(each.key))
  vpc_security_group_ids = var.vpc_security_group_ids

  # User data with RDS endpoint templating
  user_data = var.app3_user_data_template_path != "" && var.rds_db_endpoint != "" ? templatefile(
    var.app3_user_data_template_path,
    { rds_db_endpoint = var.rds_db_endpoint }
  ) : null

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name_prefix}-app3-dnsdb-${each.key}"
    }
  )
}

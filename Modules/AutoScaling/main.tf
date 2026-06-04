# AutoScaling Module
# Creates launch template, auto scaling group, scaling policies, and notifications

# ============================================================================
# LAUNCH TEMPLATE
# ============================================================================

resource "aws_launch_template" "asg_launch_template" {
  name                   = var.launch_template_name
  description            = var.launch_template_description
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.instance_keypair
  user_data              = base64encode(var.user_data_script)
  ebs_optimized          = var.ebs_optimized
  update_default_version = var.update_default_version

  # Instance market options (Spot) - Commented out by default
  # Uncomment and configure for Spot instances
  #instance_market_options {
  #  market_type = "spot"
  #  spot_options {
  #    max_price = "0.014"
  #  }
  #}

  # Root volume block device mapping
  block_device_mappings {
    device_name = var.root_device_name
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      delete_on_termination = var.ebs_delete_on_termination
      encrypted             = var.ebs_encrypted
    }
  }

  # Secondary volume block device mapping
  block_device_mappings {
    device_name = var.secondary_device_name
    ebs {
      volume_size           = var.secondary_volume_size
      volume_type           = var.secondary_volume_type
      delete_on_termination = var.ebs_delete_on_termination
      encrypted             = var.ebs_encrypted
    }
  }

  # Monitoring
  monitoring {
    enabled = var.monitoring_enabled
  }

  # Metadata options
  metadata_options {
    http_endpoint               = var.http_endpoint
    http_tokens                 = var.http_tokens
    http_put_response_hop_limit = var.http_put_response_hop_limit
  }

  # Tag specifications for instances
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      {
        Name = "${var.asg_name_prefix}-instance"
      },
      var.lt_instance_tags != null ? var.lt_instance_tags : {}
    )
  }

}

# ============================================================================
# AUTO SCALING GROUP
# ============================================================================

resource "aws_autoscaling_group" "asg" {
  name_prefix               = var.asg_name_prefix
  desired_capacity          = var.asg_desired_capacity
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  vpc_zone_identifier       = var.private_subnets
  target_group_arns         = var.target_group_arns
  health_check_type         = var.asg_health_check_type
  health_check_grace_period = var.asg_health_check_grace_period

  # Launch Template
  launch_template {
    id      = aws_launch_template.asg_launch_template.id
    version = "$Latest"
  }

  # Lifecycle Hooks
  initial_lifecycle_hook {
    name                 = var.lifecycle_hook_launching_name
    default_result       = "CONTINUE"
    heartbeat_timeout    = var.lifecycle_hook_launching_timeout
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
  }

  initial_lifecycle_hook {
    name                 = var.lifecycle_hook_terminating_name
    default_result       = "CONTINUE"
    heartbeat_timeout    = var.lifecycle_hook_terminating_timeout
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
  }

  # Instance Refresh
  instance_refresh {
    strategy = var.instance_refresh_strategy
    preferences {
      min_healthy_percentage = var.instance_refresh_min_healthy_percentage
    }
    triggers = var.instance_refresh_triggers
  }

  # Dynamic Tags with propagate_at_launch support
  dynamic "tag" {
    for_each = var.asg_tags
    content {
      key                 = tag.value["key"]
      value               = tag.value["value"]
      propagate_at_launch = tag.value["propagate_at_launch"]
    }
  }
}

# ============================================================================
# SNS NOTIFICATIONS
# ============================================================================

# Random Pet Resource for unique SNS topic name
resource "random_pet" "asg_sns" {
  length = 2
}

# SNS Topic for autoscaling notifications
resource "aws_sns_topic" "asg_notifications" {
  name = "asg-lt-sns-topic-${random_pet.asg_sns.id}"
}

# SNS Subscription (Email)
resource "aws_sns_topic_subscription" "asg_email_subscription" {
  topic_arn = aws_sns_topic.asg_notifications.arn
  protocol  = "email"
  endpoint  = var.sns_email_endpoint
}

# Autoscaling Notifications
resource "aws_autoscaling_notification" "asg_notifications" {
  group_names = [aws_autoscaling_group.asg.name]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = aws_sns_topic.asg_notifications.arn
}

# ============================================================================
# TARGET TRACKING SCALING POLICIES
# ============================================================================

# CPU-Based Target Tracking Scaling Policy
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                      = var.ttsp_cpu_policy_name
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.asg.id
  estimated_instance_warmup = var.ttsp_estimated_instance_warmup

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.ttsp_cpu_target_value
  }
}

# ALB Request Count Target Tracking Scaling Policy (Commented Out)
# NOTE: This policy is specific to ALB and not applicable to NLB
# To enable, uncomment and provide alb_arn_suffix and target_group_arn_suffix variables
/*
resource "aws_autoscaling_policy" "alb_request_count_target_tracking" {
  name                      = "alb-target-requests-greater-than-yy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.asg.id
  estimated_instance_warmup = 120

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      # IMPORTANT: ALB module v9.x uses different output structure
      # Format: app/load-balancer-name/1234567890abcdef/targetgroup/target-group-name/1234567890abcdef
      # You need to pass both alb_arn_suffix and target_group_arn_suffix as variables
      resource_label = "${var.alb_arn_suffix}/${var.target_group_arn_suffix}"
    }
    target_value = 10.0
  }
}
*/

# ============================================================================
# SCHEDULED ACTIONS
# ============================================================================

# Scheduled Action: Increase Capacity (e.g., 7am during business hours)
resource "aws_autoscaling_schedule" "increase_capacity" {
  scheduled_action_name  = var.scheduled_action_increase_name
  min_size               = var.scheduled_action_increase_min
  max_size               = var.scheduled_action_increase_max
  desired_capacity       = var.scheduled_action_increase_desired
  start_time             = var.scheduled_action_increase_start_time
  recurrence             = var.scheduled_action_increase_recurrence
  autoscaling_group_name = aws_autoscaling_group.asg.id
}

# Scheduled Action: Decrease Capacity (e.g., 5pm after business hours)
resource "aws_autoscaling_schedule" "decrease_capacity" {
  scheduled_action_name  = var.scheduled_action_decrease_name
  min_size               = var.scheduled_action_decrease_min
  max_size               = var.scheduled_action_decrease_max
  desired_capacity       = var.scheduled_action_decrease_desired
  start_time             = var.scheduled_action_decrease_start_time
  recurrence             = var.scheduled_action_decrease_recurrence
  autoscaling_group_name = aws_autoscaling_group.asg.id
}

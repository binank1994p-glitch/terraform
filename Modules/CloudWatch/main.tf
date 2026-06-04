# CloudWatch Monitoring Module
# This module manages Auto Scaling Group alarms, ALB alarms, CIS security alarms, and Synthetics monitoring

##############################################################################
# Auto Scaling Group - CloudWatch Alarms and Scaling Policies
##############################################################################

# Autoscaling - Scaling Policy for High CPU
resource "aws_autoscaling_policy" "high_cpu" {
  name                   = "high-cpu"
  scaling_adjustment     = var.high_cpu_scaling_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.high_cpu_cooldown
  autoscaling_group_name = var.asg_name
}

# CloudWatch Alarm to trigger scaling policy when CPU > threshold
resource "aws_cloudwatch_metric_alarm" "app1_asg_cwa_cpu" {
  alarm_name          = "App1-ASG-CWA-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.high_cpu_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.high_cpu_period
  statistic           = "Average"
  threshold           = var.high_cpu_threshold

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = "This metric monitors ec2 cpu utilization and triggers the ASG Scaling policy to scale-out if CPU is above ${var.high_cpu_threshold}%"

  ok_actions = [var.asg_sns_topic_arn]
  alarm_actions = [
    aws_autoscaling_policy.high_cpu.arn,
    var.asg_sns_topic_arn
  ]
}

##############################################################################
# Application Load Balancer - CloudWatch Alarms
##############################################################################

# CloudWatch Alarm for ALB HTTP 4xx Errors
resource "aws_cloudwatch_metric_alarm" "alb_4xx_errors" {
  alarm_name          = "App1-ALB-HTTP-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = var.alb_4xx_datapoints_to_alarm
  evaluation_periods  = var.alb_4xx_evaluation_periods
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = var.alb_4xx_period
  statistic           = "Sum"
  threshold           = var.alb_4xx_threshold
  treat_missing_data  = "missing"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_description = "This metric monitors ALB HTTP 4xx errors and if they are above ${var.alb_4xx_threshold} in specified interval, it is going to send a notification email"

  ok_actions    = [var.asg_sns_topic_arn]
  alarm_actions = [var.asg_sns_topic_arn]
}

##############################################################################
# CIS Benchmark Security Alarms
##############################################################################

# Random Pet for CIS Log Group naming
resource "random_pet" "cis" {
  length = 2
}

# Create Log Group for CIS Alarms
resource "aws_cloudwatch_log_group" "cis_log_group" {
  name = "cis-log-group-${random_pet.cis.id}"
  tags = var.common_tags
}

# CIS Alarms using Terraform Module
module "all_cis_alarms" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/cis-alarms"
  version = "5.3.1"

  disabled_controls = var.cis_disabled_controls
  log_group_name    = aws_cloudwatch_log_group.cis_log_group.name
  alarm_actions     = [var.asg_sns_topic_arn]
  tags              = var.common_tags
}

##############################################################################
# CloudWatch Synthetics - Heartbeat Monitor
##############################################################################

# Random Pet for S3 Bucket naming
resource "random_pet" "synthetics" {
  length = 2
}

# IAM Policy for CloudWatch Synthetics Canary
resource "aws_iam_policy" "cw_canary_iam_policy" {
  name        = "cw-canary-iam-policy"
  path        = "/"
  description = "CloudWatch Canary Synthetic IAM Policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : "cloudwatch:PutMetricData",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "cloudwatch:namespace" : "CloudWatchSynthetics"
          }
        }
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "logs:CreateLogStream",
          "s3:ListAllMyBuckets",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "s3:GetBucketLocation",
          "xray:PutTraceSegments"
        ],
        "Resource" : "*"
      }
    ]
  })
  tags = var.common_tags
}

# IAM Role for CloudWatch Synthetics Canary
resource "aws_iam_role" "cw_canary_iam_role" {
  name        = "cw-canary-iam-role"
  description = "CloudWatch Synthetics lambda execution role for running canaries"
  path        = "/service-role/"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [aws_iam_policy.cw_canary_iam_policy.arn]
  tags                = var.common_tags
}

# S3 Bucket for CloudWatch Synthetics Artifacts
resource "aws_s3_bucket" "cw_canary_bucket" {
  bucket        = "cw-canary-bucket-${random_pet.synthetics.id}"
  force_destroy = true
  tags = merge(var.common_tags, {
    Name = "CloudWatch Canary Bucket"
  })
}


# CloudWatch Synthetics Canary - Heartbeat Monitor
resource "aws_synthetics_canary" "sswebsite_asg_lt" {
  name                 = var.canary_name
  artifact_s3_location = "s3://${aws_s3_bucket.cw_canary_bucket.id}/${var.canary_name}"
  execution_role_arn   = aws_iam_role.cw_canary_iam_role.arn
  handler              = var.canary_handler
  zip_file             = "${path.module}/synthetics/sswebsite2/sswebsite2v1.zip"
  runtime_version      = var.canary_runtime_version
  start_canary         = true

  run_config {
    active_tracing     = true
    memory_in_mb       = var.canary_memory_in_mb
    timeout_in_seconds = var.canary_timeout_in_seconds
  }

  schedule {
    expression = var.canary_schedule_expression
  }
  tags = var.common_tags
}

# CloudWatch Alarm for Synthetics Heartbeat Monitor
resource "aws_cloudwatch_metric_alarm" "synthetics_alarm_app1" {
  alarm_name          = "Synthetics-Alarm-App1"
  comparison_operator = "LessThanThreshold"
  datapoints_to_alarm = "1"
  evaluation_periods  = var.canary_alarm_evaluation_periods
  metric_name         = "SuccessPercent"
  namespace           = "CloudWatchSynthetics"
  period              = var.canary_alarm_period
  statistic           = "Average"
  threshold           = var.canary_success_percent_threshold
  treat_missing_data  = "breaching"

  dimensions = {
    CanaryName = aws_synthetics_canary.sswebsite_asg_lt.id
  }

  alarm_description = "Synthetics alarm metric: SuccessPercent LessThanThreshold ${var.canary_success_percent_threshold}"

  ok_actions    = [var.asg_sns_topic_arn]
  alarm_actions = [var.asg_sns_topic_arn]
}

# Terraform AWS Application Load Balancer (ALB) - Basic Configuration
# This module creates a basic ALB with HTTP to HTTPS redirect and a single target group
# Target attachments are managed by Auto Scaling Group (not in this module)

module "alb_basic" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.4.0"

  name               = var.alb_name
  load_balancer_type = "application"
  vpc_id             = var.vpc_id
  subnets            = var.public_subnets
  security_groups    = [var.loadbalancer_sg_id]

  enable_deletion_protection = var.enable_deletion_protection

  # Listeners
  listeners = {
    # Listener-1: HTTP listener with redirect to HTTPS
    my-http-listener = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    # Listener-2: HTTPS listener
    my-https-listener = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = var.ssl_policy
      certificate_arn = var.certificate_arn

      forward = {
        target_group_key = "mytg1_basic"
      }
    }
  } # End of listeners block

  # Target Groups
  target_groups = {
    # Target Group-1: mytg1_basic
    # Note: Target attachments are managed by Auto Scaling Group
    mytg1_basic = {
      create_attachment                 = false
      name_prefix                       = var.target_group_name_prefix
      protocol                          = var.target_group_protocol
      port                              = var.target_group_port
      target_type                       = "instance"
      deregistration_delay              = var.deregistration_delay
      load_balancing_cross_zone_enabled = false
      protocol_version                  = "HTTP1"
      health_check = {
        enabled             = true
        interval            = var.health_check_interval
        path                = var.health_check_path
        port                = "traffic-port"
        healthy_threshold   = var.healthy_threshold
        unhealthy_threshold = var.unhealthy_threshold
        timeout             = var.health_check_timeout
        protocol            = var.target_group_protocol
        matcher             = "200-399"
      }
      tags = var.common_tags
    }
  }
  tags = var.common_tags
}

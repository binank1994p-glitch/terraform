# Terraform AWS Application Load Balancer (ALB) - Path-Based Routing
# This module creates an ALB with path-based routing (/app1*, /app2*)
# and includes target group attachments for app1 and app2 instances

module "alb_pathbased" {

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
    # Listener-1: my-http-https-redirect
    my-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    } # End my-http-https-redirect Listener

    # Listener-2: my-https-listener
    my-https-listener = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = var.ssl_policy
      certificate_arn = var.certificate_arn

      # Fixed Response for Root Context
      fixed_response = {
        content_type = "text/plain"
        message_body = var.fixed_response_message
        status_code  = "200"
      } # End of Fixed Response

      # Load Balancer Rules
      rules = {
        # Rule-1: myapp1-rule
        myapp1-rule = {
          actions = [{
            type = "weighted-forward"
            target_groups = [
              {
                target_group_key = "mytg1_pathbased"
                weight           = 1
              }
            ]
            stickiness = {
              enabled  = true
              duration = var.stickiness_duration
            }
          }]
          conditions = [{
            path_pattern = {
              values = ["/app1*"]
            }
          }]
        } # End of myapp1-rule
        # Rule-2: myapp2-rule
        myapp2-rule = {
          actions = [{
            type = "weighted-forward"
            target_groups = [
              {
                target_group_key = "mytg2_pathbased"
                weight           = 1
              }
            ]
            stickiness = {
              enabled  = true
              duration = var.stickiness_duration
            }
          }]
          conditions = [{
            path_pattern = {
              values = ["/app2*"]
            }
          }]
        } # End of myapp2-rule Block
      }   # End Rules Block
    }     # End my-https-listener Block
  }       # End Listeners Block

  # Target Groups
  target_groups = {
    # Target Group-1: mytg1_pathbased
    mytg1_pathbased = {
      # VERY IMPORTANT: We will create aws_lb_target_group_attachment resource separately when we use create_attachment = false
      # Github ISSUE: https://github.com/terraform-aws-modules/terraform-aws-alb/issues/316
      create_attachment                 = false
      name_prefix                       = "mtg1p-"
      protocol                          = var.target_group_protocol
      port                              = var.target_group_port
      target_type                       = "instance"
      deregistration_delay              = var.deregistration_delay
      load_balancing_cross_zone_enabled = false
      protocol_version                  = "HTTP1"
      health_check = {
        enabled             = true
        interval            = var.health_check_interval
        path                = var.app1_health_check_path
        port                = "traffic-port"
        healthy_threshold   = var.healthy_threshold
        unhealthy_threshold = var.unhealthy_threshold
        timeout             = var.health_check_timeout
        protocol            = var.target_group_protocol
        matcher             = "200-399"
      } # End of Health Check Block
      tags = var.common_tags
    } # END of Target Group-1: mytg1_pathbased

    # Target Group-2: mytg2_pathbased
    mytg2_pathbased = {
      # VERY IMPORTANT: We will create aws_lb_target_group_attachment resource separately when we use create_attachment = false
      # Github ISSUE: https://github.com/terraform-aws-modules/terraform-aws-alb/issues/316
      create_attachment                 = false
      name_prefix                       = "mtg2p-"
      protocol                          = var.target_group_protocol
      port                              = var.target_group_port
      target_type                       = "instance"
      deregistration_delay              = var.deregistration_delay
      load_balancing_cross_zone_enabled = false
      protocol_version                  = "HTTP1"
      health_check = {
        enabled             = true
        interval            = var.health_check_interval
        path                = var.app2_health_check_path
        port                = "traffic-port"
        healthy_threshold   = var.healthy_threshold
        unhealthy_threshold = var.unhealthy_threshold
        timeout             = var.health_check_timeout
        protocol            = var.target_group_protocol
        matcher             = "200-399"
      } # End of Health Check Block
      tags = var.common_tags
    } # END of Target Group-2: mytg2_pathbased
  }   # END OF target_groups
  tags = var.common_tags
} # End of alb_pathbased module

# mytg1_pathbased: LB Target Group Attachment for App1 instances
resource "aws_lb_target_group_attachment" "mytg1_pathbased" {
  for_each         = var.app1_instances
  target_group_arn = module.alb_pathbased.target_groups["mytg1_pathbased"].arn
  target_id        = each.value.id
  port             = var.target_group_port
}

# mytg2_pathbased: LB Target Group Attachment for App2 instances
resource "aws_lb_target_group_attachment" "mytg2_pathbased" {
  for_each         = var.app2_instances
  target_group_arn = module.alb_pathbased.target_groups["mytg2_pathbased"].arn
  target_id        = each.value.id
  port             = var.target_group_port
}

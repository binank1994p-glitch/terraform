# Terraform AWS Application Load Balancer (ALB) - Host Header Based Routing
# This module creates an ALB with host-header based routing for multiple applications
# Target attachments are managed by Auto Scaling Groups or externally (not in this module)

module "alb_hostheader" {
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
        content_type = var.fixed_response_content_type
        message_body = var.fixed_response_message_body
        status_code  = var.fixed_response_status_code
      } # End of Fixed Response

      # Load Balancer Rules
      rules = {
        # Rule-1: myapp1-rule
        myapp1-rule = {
          actions = [{
            type = "weighted-forward"
            target_groups = [
              {
                target_group_key = "mytg1_hostheader"
                weight           = 1
              }
            ]
            stickiness = {
              enabled  = var.stickiness_enabled
              duration = var.stickiness_duration
            }
          }]
          conditions = [{
            host_header = {
              values = [var.app1_dns_name]
            }
          }]
        } # End of myapp1-rule
        # Rule-2: myapp2-rule
        myapp2-rule = {
          actions = [{
            type = "weighted-forward"
            target_groups = [
              {
                target_group_key = "mytg2_hostheader"
                weight           = 1
              }
            ]
            stickiness = {
              enabled  = var.stickiness_enabled
              duration = var.stickiness_duration
            }
          }]
          conditions = [{
            host_header = {
              values = [var.app2_dns_name]
            }
          }]
        } # End of myapp2-rule Block
      }   # End Rules Block
    }     # End my-https-listener Block
  }       # End Listeners Block

  # Target Groups
  target_groups = {
    # Target Group-1: mytg1_hostheader
    mytg1_hostheader = {
      # VERY IMPORTANT: We will create aws_lb_target_group_attachment resource separately when we use create_attachment = false
      # Github ISSUE: https://github.com/terraform-aws-modules/terraform-aws-alb/issues/316
      create_attachment                 = false
      name_prefix                       = var.target_group_1_name_prefix
      protocol                          = var.target_group_protocol
      port                              = var.target_group_port
      target_type                       = "instance"
      deregistration_delay              = var.deregistration_delay
      load_balancing_cross_zone_enabled = false
      protocol_version                  = var.protocol_version
      health_check = {
        enabled             = true
        interval            = var.health_check_interval
        path                = var.app1_health_check_path
        port                = "traffic-port"
        healthy_threshold   = var.healthy_threshold
        unhealthy_threshold = var.unhealthy_threshold
        timeout             = var.health_check_timeout
        protocol            = var.target_group_protocol
        matcher             = var.health_check_matcher
      } # End of Health Check Block
      tags = var.common_tags
    } # END of Target Group-1: mytg1_hostheader

    # Target Group-2: mytg2_hostheader
    mytg2_hostheader = {
      # VERY IMPORTANT: We will create aws_lb_target_group_attachment resource separately when we use create_attachment = false
      # Github ISSUE: https://github.com/terraform-aws-modules/terraform-aws-alb/issues/316
      create_attachment                 = false
      name_prefix                       = var.target_group_2_name_prefix
      protocol                          = var.target_group_protocol
      port                              = var.target_group_port
      target_type                       = "instance"
      deregistration_delay              = var.deregistration_delay
      load_balancing_cross_zone_enabled = false
      protocol_version                  = var.protocol_version
      health_check = {
        enabled             = true
        interval            = var.health_check_interval
        path                = var.app2_health_check_path
        port                = "traffic-port"
        healthy_threshold   = var.healthy_threshold
        unhealthy_threshold = var.unhealthy_threshold
        timeout             = var.health_check_timeout
        protocol            = var.target_group_protocol
        matcher             = var.health_check_matcher
      } # End of Health Check Block
      tags = var.common_tags
    } # END of Target Group-2: mytg2_hostheader
  }   # END OF target_groups
  tags = var.common_tags
} # End of alb_hostheader module

# Note: Target group attachments are managed by Auto Scaling Groups or externally
# If needed, they can be added using aws_lb_target_group_attachment resources
# referencing module.alb_hostheader.target_groups["mytg1_hostheader"].arn
# and module.alb_hostheader.target_groups["mytg2_hostheader"].arn

# Terraform AWS Application Load Balancer (ALB) - DNS-to-DB
# This module creates an Application Load Balancer for DNS-to-Database routing with:
# - Path-based routing to three applications
# - App1 and App2: Standard web applications on port 80
# - App3: User Management System on port 8080 (connected to RDS database)
# - HTTP to HTTPS redirect
# - Fixed response for root context

module "alb_dnsdb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.4.0"

  name               = var.alb_name
  load_balancer_type = "application"
  vpc_id             = var.vpc_id
  subnets            = var.public_subnets
  security_groups    = [var.loadbalancer_sg_id]

  # Deletion protection
  enable_deletion_protection = var.enable_deletion_protection

  # Listeners
  listeners = {
    # Listener-1: HTTP to HTTPS redirect
    my-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    } # End my-http-https-redirect Listener

    # Listener-2: HTTPS listener with certificate and path-based routing
    my-https-listener = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = var.ssl_policy
      certificate_arn = var.certificate_arn

      # Fixed Response for Root Context (default action when no paths match)
      fixed_response = {
        content_type = var.fixed_response_content_type
        message_body = var.fixed_response_message_body
        status_code  = var.fixed_response_status_code
      } # End of Fixed Response

      # Load Balancer Rules
      rules = {
        # Rule-1: Path-based routing to App1 (/app1*)
        myapp1-dnsdb-rule = {
          priority = var.app1_rule_priority
          actions = [{
            type = "weighted-forward"
            target_groups = [
              {
                target_group_key = "mytg1_dnsdb"
                weight           = 1
              }
            ]
            stickiness = {
              enabled  = var.stickiness_enabled
              duration = var.stickiness_duration
            }
          }]
          conditions = [{
            path_pattern = {
              values = [var.app1_path_pattern]
            }
          }]
        } # End of myapp1-dnsdb-rule

        # Rule-2: Path-based routing to App2 (/app2*)
        myapp2-dnsdb-rule = {
          priority = var.app2_rule_priority
          actions = [{
            type = "weighted-forward"
            target_groups = [
              {
                target_group_key = "mytg2_dnsdb"
                weight           = 1
              }
            ]
            stickiness = {
              enabled  = var.stickiness_enabled
              duration = var.stickiness_duration
            }
          }]
          conditions = [{
            path_pattern = {
              values = [var.app2_path_pattern]
            }
          }]
        } # End of myapp2-dnsdb-rule Block

        # Rule-3: Path-based routing to App3 - User Management System (/* catch-all)
        myapp3-dnsdb-rule = {
          priority = var.app3_rule_priority
          actions = [{
            type = "weighted-forward"
            target_groups = [
              {
                target_group_key = "mytg3_dnsdb"
                weight           = 1
              }
            ]
            stickiness = {
              enabled  = var.stickiness_enabled
              duration = var.stickiness_duration
            }
          }]
          conditions = [{
            path_pattern = {
              values = [var.app3_path_pattern]
            }
          }]
        } # End of myapp3-dnsdb-rule Block
      }   # End Rules
    }     # End Listener-2: my-https-listener
  }       # End Listeners

  # Target Groups
  target_groups = {
    # Target Group-1: mytg1_dnsdb (App1 on port 80)
    mytg1_dnsdb = {
      # IMPORTANT: Target attachments are managed by Auto Scaling Groups or externally
      # We use create_attachment = false to avoid conflicts
      # Reference: https://github.com/terraform-aws-modules/terraform-aws-alb/issues/316
      create_attachment                 = false
      name_prefix                       = var.target_group_1_name_prefix
      protocol                          = var.target_group_protocol
      port                              = var.target_group_1_port
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
    } # END of Target Group-1: mytg1_dnsdb

    # Target Group-2: mytg2_dnsdb (App2 on port 80)
    mytg2_dnsdb = {
      # IMPORTANT: Target attachments are managed by Auto Scaling Groups or externally
      # We use create_attachment = false to avoid conflicts
      # Reference: https://github.com/terraform-aws-modules/terraform-aws-alb/issues/316
      create_attachment                 = false
      name_prefix                       = var.target_group_2_name_prefix
      protocol                          = var.target_group_protocol
      port                              = var.target_group_2_port
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
      }
      tags = var.common_tags
    } # END of Target Group-2: mytg2_dnsdb

    # Target Group-3: mytg3_dnsdb (App3 - User Management System on port 8080)
    mytg3_dnsdb = {
      # IMPORTANT: Target attachments are managed by Auto Scaling Groups or externally
      # We use create_attachment = false to avoid conflicts
      # Reference: https://github.com/terraform-aws-modules/terraform-aws-alb/issues/316
      create_attachment                 = false
      name_prefix                       = var.target_group_3_name_prefix
      protocol                          = var.target_group_protocol
      port                              = var.target_group_3_port
      target_type                       = "instance"
      deregistration_delay              = var.deregistration_delay
      load_balancing_cross_zone_enabled = false
      protocol_version                  = var.protocol_version
      health_check = {
        enabled             = true
        interval            = var.health_check_interval
        path                = var.app3_health_check_path
        port                = "traffic-port"
        healthy_threshold   = var.healthy_threshold
        unhealthy_threshold = var.unhealthy_threshold
        timeout             = var.health_check_timeout
        protocol            = var.target_group_protocol
        matcher             = var.health_check_matcher
      }
      tags = var.common_tags
    } # END of Target Group-3: mytg3_dnsdb
  }   # END OF target_groups

  tags = var.common_tags
}

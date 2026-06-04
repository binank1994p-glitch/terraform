# Terraform AWS Application Load Balancer (ALB) - Custom Routing
# This module creates an Application Load Balancer with advanced routing rules:
# - HTTP header-based routing to different target groups
# - Query string-based redirects to external sites
# - Host header-based redirects to external sites
# - Fixed response for root context

module "alb_customrouting" {
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

    # Listener-2: HTTPS listener with certificate and routing rules
    my-https-listener = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = var.ssl_policy
      certificate_arn = var.certificate_arn

      # Fixed Response for Root Context (default action when no rules match)
      fixed_response = {
        content_type = var.fixed_response_content_type
        message_body = var.fixed_response_message_body
        status_code  = var.fixed_response_status_code
      } # End of Fixed Response

      # Load Balancer Rules
      rules = {
        # Rule-1: HTTP header routing to App1 (custom-header with multiple values)
        myapp1-rule = {
          priority = 1
          actions = [{
            type = "weighted-forward"
            target_groups = [
              {
                target_group_key = "mytg1_customrouting"
                weight           = 1
              }
            ]
            stickiness = {
              enabled  = var.stickiness_enabled
              duration = var.stickiness_duration
            }
          }]
          conditions = [{
            http_header = {
              http_header_name = var.app1_http_header_name
              values           = var.app1_http_header_values
            }
          }]
        } # End of myapp1-rule

        # Rule-2: HTTP header routing to App2 (custom-header with multiple values)
        myapp2-rule = {
          priority = 2
          actions = [{
            type = "weighted-forward"
            target_groups = [
              {
                target_group_key = "mytg2_customrouting"
                weight           = 1
              }
            ]
            stickiness = {
              enabled  = var.stickiness_enabled
              duration = var.stickiness_duration
            }
          }]
          conditions = [{
            http_header = {
              http_header_name = var.app2_http_header_name
              values           = var.app2_http_header_values
            }
          }]
        } # End of myapp2-rule Block

        # Rule-3: Query String Redirect Rule (website=aws-eks -> external site)
        my-redirect-query = {
          priority = 3
          actions = [{
            type        = "redirect"
            status_code = var.query_redirect_status_code
            host        = var.query_redirect_host
            path        = var.query_redirect_path
            query       = ""
            protocol    = "HTTPS"
          }]

          conditions = [{
            query_string = {
              key   = var.query_string_key
              value = var.query_string_value
            }
          }]
        } # End of Rule-3 Query String Redirect Rule

        # Rule-4: Host Header Redirect (specific DNS name -> external site)
        my-redirect-hh = {
          priority = 4
          actions = [{
            type        = "redirect"
            status_code = var.host_header_redirect_status_code
            host        = var.host_header_redirect_host
            path        = var.host_header_redirect_path
            query       = ""
            protocol    = "HTTPS"
          }]

          conditions = [{
            host_header = {
              values = [var.redirect_dns_name]
            }
          }]
        } # Rule-4: Host Header Redirect
      }   # End Rules
    }     # End Listener-2: my-https-listener
  }       # End Listeners

  # Target Groups
  target_groups = {
    # Target Group-1: mytg1_customrouting (for App1)
    mytg1_customrouting = {
      # IMPORTANT: Target attachments are managed by Auto Scaling Groups or externally
      # We use create_attachment = false to avoid conflicts
      # Reference: https://github.com/terraform-aws-modules/terraform-aws-alb/issues/316
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
    } # END of Target Group-1: mytg1_customrouting

    # Target Group-2: mytg2_customrouting (for App2)
    mytg2_customrouting = {
      # IMPORTANT: Target attachments are managed by Auto Scaling Groups or externally
      # We use create_attachment = false to avoid conflicts
      # Reference: https://github.com/terraform-aws-modules/terraform-aws-alb/issues/316
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
      }
      tags = var.common_tags
    } # END of Target Group-2: mytg2_customrouting
  }   # END OF target_groups

  tags = var.common_tags
}

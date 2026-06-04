# Terraform AWS Network Load Balancer (NLB)
# This module creates a Network Load Balancer with TCP and TLS listeners

module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.4.0"

  name_prefix                      = var.nlb_name_prefix
  load_balancer_type               = "network"
  vpc_id                           = var.vpc_id
  dns_record_client_routing_policy = var.dns_record_client_routing_policy
  security_groups                  = [var.loadbalancer_sg_id]

  # https://github.com/hashicorp/terraform-provider-aws/issues/17281
  subnets = var.public_subnets

  enable_deletion_protection = var.enable_deletion_protection

  # Listeners
  listeners = {
    # Listener-1: TCP Listener
    my-tcp = {
      port     = var.tcp_listener_port
      protocol = "TCP"
      forward = {
        target_group_key = "mytg1"
      }
    } # End Listener-1: TCP Listener
    # Listener-2: TLS Listener (SSL)
    my-tls = {
      port            = var.tls_listener_port
      protocol        = "TLS"
      certificate_arn = var.certificate_arn
      forward = {
        target_group_key = "mytg1"
      }
    } # End Listener-2: TLS Listener (SSL)
  }   # End Listeners Block

  # Target Groups
  target_groups = {
    # Target Group-1: mytg1
    mytg1 = {
      create_attachment    = false
      name_prefix          = var.target_group_name_prefix
      protocol             = var.target_group_protocol
      port                 = var.target_group_port
      target_type          = "instance"
      deregistration_delay = var.deregistration_delay
      health_check = {
        enabled             = var.health_check_enabled
        interval            = var.health_check_interval
        path                = var.health_check_path
        port                = var.health_check_port
        healthy_threshold   = var.healthy_threshold
        unhealthy_threshold = var.unhealthy_threshold
        timeout             = var.health_check_timeout
      } # End Health Check Block
    }   # End Target Group-1: mytg1
  }
  tags = var.common_tags
} # End NLB Module

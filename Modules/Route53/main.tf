# Get DNS information from AWS Route53
data "aws_route53_zone" "mydomain" {
  name = var.hosted_zone_name
}

# DNS Registration for Path-Based ALB
resource "aws_route53_record" "apps_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = var.dns_name
  type    = "A"
  alias {
    name                   = var.alb_pathbased_dns_name
    zone_id                = var.alb_pathbased_zone_id
    evaluate_target_health = true
  }
}

# DNS Registration for Host-Header ALB - App1
resource "aws_route53_record" "app1_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = var.app1_dns_name
  type    = "A"
  alias {
    name                   = var.alb_hostheader_dns_name
    zone_id                = var.alb_hostheader_zone_id
    evaluate_target_health = true
  }
}

# DNS Registration for Host-Header ALB - App2
resource "aws_route53_record" "app2_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = var.app2_dns_name
  type    = "A"
  alias {
    name                   = var.alb_hostheader_dns_name
    zone_id                = var.alb_hostheader_zone_id
    evaluate_target_health = true
  }
}

# DNS Registration for Custom Routing ALB - Default DNS
resource "aws_route53_record" "default_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = var.default_dns_name
  type    = "A"
  alias {
    name                   = var.alb_customrouting_dns_name
    zone_id                = var.alb_customrouting_zone_id
    evaluate_target_health = true
  }
}

# DNS Registration for Custom Routing ALB - Redirect DNS (Host Header Test)
resource "aws_route53_record" "redirect_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = var.redirect_dns_name
  type    = "A"
  alias {
    name                   = var.alb_customrouting_dns_name
    zone_id                = var.alb_customrouting_zone_id
    evaluate_target_health = true
  }
}

# DNS Registration for DNS-to-DB ALB
resource "aws_route53_record" "dnsdb_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = var.dns_to_db_name
  type    = "A"
  alias {
    name                   = var.alb_dnsdb_dns_name
    zone_id                = var.alb_dnsdb_zone_id
    evaluate_target_health = true
  }
}

# DNS Record for ASG with Launch Template Demo
resource "aws_route53_record" "asg_lt_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = "asg-lt.${data.aws_route53_zone.mydomain.name}"
  type    = "A"
  alias {
    name                   = var.alb_basic_dns_name
    zone_id                = var.alb_basic_zone_id
    evaluate_target_health = true
  }
}

# DNS Registration for NLB
resource "aws_route53_record" "nlb_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = "nlb.${data.aws_route53_zone.mydomain.name}"
  type    = "A"
  alias {
    name                   = var.nlb_dns_name
    zone_id                = var.nlb_zone_id
    evaluate_target_health = true
  }
}

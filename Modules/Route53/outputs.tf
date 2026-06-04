# Output definitions for Route53 module

# Route53 Hosted Zone Outputs
output "route53_zone_id" {
  description = "The Hosted Zone ID of the desired Hosted Zone"
  value       = data.aws_route53_zone.mydomain.zone_id
}

output "route53_zone_name" {
  description = "The Hosted Zone name of the desired Hosted Zone"
  value       = data.aws_route53_zone.mydomain.name
}

output "route53_zone_name_servers" {
  description = "Name servers for the Route53 hosted zone"
  value       = data.aws_route53_zone.mydomain.name_servers
}

# DNS Record Outputs - Path-Based ALB
output "apps_dns_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) for Path-Based ALB"
  value       = aws_route53_record.apps_dns.fqdn
}

output "apps_dns_name" {
  description = "DNS name for Path-Based ALB"
  value       = aws_route53_record.apps_dns.name
}

# DNS Record Outputs - Host-Header ALB App1
output "app1_dns_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) for App1 Host-Header routing"
  value       = aws_route53_record.app1_dns.fqdn
}

output "app1_dns_name" {
  description = "DNS name for App1 Host-Header routing"
  value       = aws_route53_record.app1_dns.name
}

# DNS Record Outputs - Host-Header ALB App2
output "app2_dns_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) for App2 Host-Header routing"
  value       = aws_route53_record.app2_dns.fqdn
}

output "app2_dns_name" {
  description = "DNS name for App2 Host-Header routing"
  value       = aws_route53_record.app2_dns.name
}

# DNS Record Outputs - Custom Routing ALB Default
output "default_dns_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) for Custom Routing ALB Default"
  value       = aws_route53_record.default_dns.fqdn
}

output "default_dns_name" {
  description = "DNS name for Custom Routing ALB Default"
  value       = aws_route53_record.default_dns.name
}

# DNS Record Outputs - Custom Routing ALB Redirect
output "redirect_dns_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) for Host Header Redirect Testing"
  value       = aws_route53_record.redirect_dns.fqdn
}

output "redirect_dns_name" {
  description = "DNS name for Host Header Redirect Testing"
  value       = aws_route53_record.redirect_dns.name
}

# DNS Record Outputs - DNS-to-DB ALB
output "dnsdb_dns_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) for DNS-to-DB ALB"
  value       = aws_route53_record.dnsdb_dns.fqdn
}

output "dnsdb_dns_name" {
  description = "DNS name for DNS-to-DB ALB"
  value       = aws_route53_record.dnsdb_dns.name
}

# DNS Record Outputs - ASG with Launch Template
output "asg_lt_dns_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) for ASG with Launch Template"
  value       = aws_route53_record.asg_lt_dns.fqdn
}

output "asg_lt_dns_name" {
  description = "DNS name for ASG with Launch Template"
  value       = aws_route53_record.asg_lt_dns.name
}

# DNS Record Outputs - NLB
output "nlb_dns_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) for Network Load Balancer"
  value       = aws_route53_record.nlb_dns.fqdn
}

output "nlb_dns_name" {
  description = "DNS name for Network Load Balancer"
  value       = aws_route53_record.nlb_dns.name
}

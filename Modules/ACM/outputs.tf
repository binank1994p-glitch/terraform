# Output definitions for ACM module

# ACM Certificate Outputs
output "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = module.acm.acm_certificate_arn
}

output "acm_certificate_domain_validation_options" {
  description = "Domain validation options for the certificate"
  value       = module.acm.acm_certificate_domain_validation_options
}

output "acm_certificate_status" {
  description = "Status of the certificate"
  value       = module.acm.acm_certificate_status
}

# Route53 Zone Outputs
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

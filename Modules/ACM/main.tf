# Get DNS information from AWS Route53
data "aws_route53_zone" "mydomain" {
  name = var.domain_name
}

# ACM Module - To create and Verify SSL Certificates
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.0"

  domain_name = trimsuffix(data.aws_route53_zone.mydomain.name, ".")
  zone_id     = data.aws_route53_zone.mydomain.zone_id

  subject_alternative_names = var.subject_alternative_names

  tags = var.common_tags

  # Validation Method
  validation_method   = var.validation_method
  wait_for_validation = var.wait_for_validation
}

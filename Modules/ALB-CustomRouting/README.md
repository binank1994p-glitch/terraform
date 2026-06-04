# ALB-CustomRouting Module

## Overview

This module creates an AWS Application Load Balancer with advanced custom routing capabilities including:
- HTTP header-based routing to different target groups
- Query string-based redirects to external sites
- Host header-based redirects to external sites
- Fixed response for root context (default route)
- HTTP to HTTPS redirect with TLS 1.3 support

## Features

- **HTTP to HTTPS Redirect**: Automatic redirect from port 80 to port 443 with HTTP_301 status
- **HTTPS Listener**: Secured with ACM certificate and configurable TLS policy
- **HTTP Header Routing**: Routes traffic based on custom HTTP headers (e.g., "custom-header: app-1")
- **Query String Redirects**: Redirects based on query parameters (e.g., "?website=aws-eks")
- **Host Header Redirects**: Redirects based on host header matching
- **Weighted Forward Actions**: Routes with session stickiness (3600s default)
- **Fixed Response**: Default response for root context when no rules match
- **Two Target Groups**: Separate target groups for different applications
- **Health Checks**: Configurable health checks for each target group

## Architecture

```
Internet → ALB (Port 80/443)
           ├─ HTTP (80) → Redirect to HTTPS (443)
           └─ HTTPS (443)
              ├─ Default: Fixed Response (200 OK)
              ├─ Rule 1 (Priority 1): custom-header=[app-1|app1|my-app-1] → Target Group 1
              ├─ Rule 2 (Priority 2): custom-header=[app-2|app2|my-app-2] → Target Group 2
              ├─ Rule 3 (Priority 3): ?website=aws-eks → Redirect to external site
              └─ Rule 4 (Priority 4): Host header match → Redirect to external site
```

## Usage

```hcl
module "alb_customrouting" {
  source = "./Modules/ALB-CustomRouting"

  # ALB Configuration
  alb_name            = "my-custom-alb"
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnets
  loadbalancer_sg_id  = module.security_groups.loadbalancer_sg_id
  certificate_arn     = module.acm.acm_certificate_arn

  # DNS Configuration
  default_dns_name  = "custom.example.com"
  redirect_dns_name = "redirect.example.com"

  # Target Group Configuration
  target_group_1_name_prefix = "mtg1c-"
  target_group_2_name_prefix = "mtg2c-"

  # HTTP Header Routing
  app1_http_header_name   = "custom-header"
  app1_http_header_values = ["app-1", "app1", "my-app-1"]
  app2_http_header_name   = "custom-header"
  app2_http_header_values = ["app-2", "app2", "my-app-2"]

  # Query String Redirect
  query_string_key            = "website"
  query_string_value          = "aws-eks"
  query_redirect_host         = "stacksimplify.com"
  query_redirect_path         = "/aws-eks/"
  query_redirect_status_code  = "HTTP_302"

  # Host Header Redirect
  host_header_redirect_host        = "stacksimplify.com"
  host_header_redirect_path        = "/azure-aks/azure-kubernetes-service-introduction/"
  host_header_redirect_status_code = "HTTP_302"

  # Health Checks
  app1_health_check_path = "/app1/index.html"
  app2_health_check_path = "/app2/index.html"
  health_check_interval  = 30
  health_check_timeout   = 6

  # Stickiness
  stickiness_enabled  = true
  stickiness_duration = 3600

  # Fixed Response
  fixed_response_content_type  = "text/plain"
  fixed_response_message_body  = "Fixed Static message - for Root Context"
  fixed_response_status_code   = "200"

  # Tags
  common_tags = {
    Environment = "production"
    Project     = "custom-routing"
  }
}
```

## Testing the Routing Rules

### Test HTTP Header Routing to App1
```bash
curl -H "custom-header: app-1" https://custom.example.com
# or
curl -H "custom-header: app1" https://custom.example.com
# or
curl -H "custom-header: my-app-1" https://custom.example.com
```

### Test HTTP Header Routing to App2
```bash
curl -H "custom-header: app-2" https://custom.example.com
# or
curl -H "custom-header: app2" https://custom.example.com
# or
curl -H "custom-header: my-app-2" https://custom.example.com
```

### Test Query String Redirect
```bash
curl -I "https://custom.example.com?website=aws-eks"
# Should redirect to: https://stacksimplify.com/aws-eks/
```

### Test Host Header Redirect
```bash
curl -I -H "Host: redirect.example.com" https://custom.example.com
# Should redirect to: https://stacksimplify.com/azure-aks/azure-kubernetes-service-introduction/
```

### Test Fixed Response (Root Context)
```bash
curl https://custom.example.com
# Should return: "Fixed Static message - for Root Context"
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| alb_name | Name for the Application Load Balancer | string | n/a | yes |
| vpc_id | VPC ID where the ALB will be created | string | n/a | yes |
| public_subnets | List of public subnet IDs for the ALB | list(string) | n/a | yes |
| loadbalancer_sg_id | Security group ID for the ALB | string | n/a | yes |
| certificate_arn | ARN of the ACM certificate for HTTPS | string | n/a | yes |
| default_dns_name | Default DNS name for Custom Routing ALB | string | n/a | yes |
| redirect_dns_name | DNS name for Host Header Redirect testing | string | n/a | yes |
| ssl_policy | SSL policy for HTTPS listener | string | "ELBSecurityPolicy-TLS13-1-2-Res-2021-06" | no |
| enable_deletion_protection | Enable deletion protection | bool | false | no |
| target_group_1_name_prefix | Name prefix for target group 1 | string | "mtg1c-" | no |
| target_group_2_name_prefix | Name prefix for target group 2 | string | "mtg2c-" | no |
| app1_http_header_name | HTTP header name for App1 routing | string | "custom-header" | no |
| app1_http_header_values | HTTP header values for App1 routing | list(string) | ["app-1", "app1", "my-app-1"] | no |
| app2_http_header_name | HTTP header name for App2 routing | string | "custom-header" | no |
| app2_http_header_values | HTTP header values for App2 routing | list(string) | ["app-2", "app2", "my-app-2"] | no |
| query_string_key | Query string key for redirect | string | "website" | no |
| query_string_value | Query string value for redirect | string | "aws-eks" | no |
| query_redirect_host | Host to redirect to for query string | string | "stacksimplify.com" | no |
| query_redirect_path | Path to redirect to for query string | string | "/aws-eks/" | no |
| query_redirect_status_code | HTTP status for query redirect | string | "HTTP_302" | no |
| host_header_redirect_host | Host to redirect to for host header | string | "stacksimplify.com" | no |
| host_header_redirect_path | Path to redirect to for host header | string | "/azure-aks/..." | no |
| host_header_redirect_status_code | HTTP status for host redirect | string | "HTTP_302" | no |
| app1_health_check_path | Health check path for App1 | string | "/app1/index.html" | no |
| app2_health_check_path | Health check path for App2 | string | "/app2/index.html" | no |
| health_check_interval | Health check interval in seconds | number | 30 | no |
| health_check_timeout | Health check timeout in seconds | number | 6 | no |
| healthy_threshold | Healthy threshold count | number | 3 | no |
| unhealthy_threshold | Unhealthy threshold count | number | 3 | no |
| health_check_matcher | HTTP status codes for healthy | string | "200-399" | no |
| stickiness_enabled | Enable session stickiness | bool | true | no |
| stickiness_duration | Stickiness duration in seconds | number | 3600 | no |
| fixed_response_content_type | Content type for fixed response | string | "text/plain" | no |
| fixed_response_message_body | Message body for fixed response | string | "Fixed Static message - for Root Context" | no |
| fixed_response_status_code | Status code for fixed response | string | "200" | no |
| common_tags | Common tags for all resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_customrouting_id | The ID of the load balancer |
| alb_customrouting_arn | The ARN of the load balancer |
| alb_customrouting_arn_suffix | ARN suffix for CloudWatch |
| alb_customrouting_dns_name | The DNS name of the load balancer |
| alb_customrouting_zone_id | The zone_id for DNS records |
| alb_customrouting_listeners | Map of listeners (sensitive) |
| alb_customrouting_listener_rules | Map of listener rules (sensitive) |
| alb_customrouting_target_groups | Map of target groups |
| alb_customrouting_target_group_1_arn | ARN of target group 1 |
| alb_customrouting_target_group_2_arn | ARN of target group 2 |

## Dependencies

This module depends on:
- **VPC Module**: Provides vpc_id and public_subnets
- **SecurityGroups Module**: Provides loadbalancer_sg_id
- **ACM Module**: Provides certificate_arn for HTTPS

## Important Notes

1. **Target Attachments**: This module uses `create_attachment = false` for both target groups. Target attachments should be managed externally by Auto Scaling Groups or manual aws_lb_target_group_attachment resources.

2. **Routing Priority**: Rules are evaluated in order of priority (1, 2, 3, 4). Lower numbers have higher priority.

3. **Default Action**: The fixed response is the default action when no routing rules match.

4. **Stickiness**: Session stickiness is configured for 3600 seconds (1 hour) by default for weighted forward actions.

5. **Cross-Zone Load Balancing**: Disabled by default for cost optimization.

6. **Deregistration Delay**: Set to 10 seconds for faster deployments.

## Terraform AWS ALB Module

This module uses the official [terraform-aws-modules/alb/aws](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest) version 9.4.0.

## Version Requirements

- Terraform >= 1.0
- AWS Provider >= 5.0
- terraform-aws-modules/alb/aws ~> 9.4.0

## Authors

Generated from consolidated Terraform configuration files.

## License

This module is released under the MIT License.

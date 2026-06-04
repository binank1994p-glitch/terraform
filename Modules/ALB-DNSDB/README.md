# ALB-DNSDB Module

## Overview

This module creates an AWS Application Load Balancer specifically designed for DNS-to-Database routing scenarios. It provides path-based routing to three applications, including a User Management System (UMS) connected to an RDS database.

## Features

- **HTTP to HTTPS Redirect**: Automatic redirect from port 80 to port 443 with HTTP_301 status
- **HTTPS Listener**: Secured with ACM certificate and configurable TLS policy
- **Path-Based Routing**: Routes traffic based on URL paths to three different applications
- **Three Target Groups**:
  - App1: Standard web application on port 80
  - App2: Standard web application on port 80
  - App3: User Management System on port 8080 (RDS-connected)
- **Weighted Forward Actions**: Routes with session stickiness (3600s default)
- **Fixed Response**: Default response for root context when no paths match
- **Health Checks**: Customized health checks for each application
- **Configurable Priorities**: Rule priorities (10, 20, 30) ensure proper routing order

## Architecture

```
Internet → ALB (Port 80/443)
           ├─ HTTP (80) → Redirect to HTTPS (443)
           └─ HTTPS (443)
              ├─ Default: Fixed Response (200 OK)
              ├─ Rule 1 (Priority 10): /app1* → Target Group 1 (Port 80)
              ├─ Rule 2 (Priority 20): /app2* → Target Group 2 (Port 80)
              └─ Rule 3 (Priority 30): /*     → Target Group 3 (Port 8080) [UMS + RDS]
```

## Application Details

### App1 - Standard Web Application
- **Port**: 80
- **Path**: `/app1*`
- **Health Check**: `/app1/index.html`
- **Priority**: 10 (highest)

### App2 - Standard Web Application
- **Port**: 80
- **Path**: `/app2*`
- **Health Check**: `/app2/index.html`
- **Priority**: 20

### App3 - User Management System (UMS)
- **Port**: 8080
- **Path**: `/*` (catch-all)
- **Health Check**: `/login`
- **Priority**: 30 (lowest)
- **Special**: Connected to RDS MySQL database for user data

## Usage

### Basic Usage

```hcl
module "alb_dnsdb" {
  source = "./Modules/ALB-DNSDB"

  # ALB Configuration
  alb_name            = "dns-to-db-alb"
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnets
  loadbalancer_sg_id  = module.security_groups.loadbalancer_sg_id
  certificate_arn     = module.acm.acm_certificate_arn

  # DNS Configuration
  dns_to_db_name = "dns-to-db.myclick.agency"

  # Tags
  common_tags = {
    Environment = "production"
    Project     = "dns-to-db"
  }
}
```

### Production Configuration with Custom Settings

```hcl
module "alb_dnsdb_production" {
  source = "./Modules/ALB-DNSDB"

  # ALB Configuration
  alb_name            = "prod-dns-to-db-alb"
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnets
  loadbalancer_sg_id  = module.security_groups.loadbalancer_sg_id
  certificate_arn     = module.acm.acm_certificate_arn

  # DNS Configuration
  dns_to_db_name = "app.example.com"

  # SSL Configuration
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"

  # Target Group Configuration
  target_group_1_name_prefix = "app1-"
  target_group_2_name_prefix = "app2-"
  target_group_3_name_prefix = "ums-"
  target_group_3_port        = 8080

  # Custom Path Patterns
  app1_path_pattern = "/api/v1*"
  app2_path_pattern = "/api/v2*"
  app3_path_pattern = "/*"

  # Custom Rule Priorities
  app1_rule_priority = 5
  app2_rule_priority = 10
  app3_rule_priority = 100

  # Health Check Configuration
  app1_health_check_path = "/health"
  app2_health_check_path = "/health"
  app3_health_check_path = "/login"
  health_check_interval  = 15
  health_check_timeout   = 5
  healthy_threshold      = 2
  unhealthy_threshold    = 2

  # Stickiness Configuration
  stickiness_enabled  = true
  stickiness_duration = 7200

  # Fixed Response Configuration
  fixed_response_content_type  = "application/json"
  fixed_response_message_body  = "{\"status\":\"healthy\",\"service\":\"dns-to-db\"}"
  fixed_response_status_code   = "200"

  # Tags
  common_tags = {
    Environment = "production"
    Project     = "dns-to-db"
    ManagedBy   = "Terraform"
    Compliance  = "required"
  }
}
```

## Testing the Routing

### Test App1 Access
```bash
# Test HTTPS access to App1
curl https://dns-to-db.myclick.agency/app1/index.html

# Test HTTP redirect
curl -I http://dns-to-db.myclick.agency/app1/index.html
# Should redirect to HTTPS
```

### Test App2 Access
```bash
# Test HTTPS access to App2
curl https://dns-to-db.myclick.agency/app2/index.html
```

### Test App3 (User Management System) Access
```bash
# Test HTTPS access to UMS login
curl https://dns-to-db.myclick.agency/login

# Test UMS registration
curl https://dns-to-db.myclick.agency/register

# Any other path will also route to App3 (catch-all)
curl https://dns-to-db.myclick.agency/dashboard
```

### Test Fixed Response (Root)
```bash
# Access root without any path
curl https://dns-to-db.myclick.agency
# Should return: "Fixed Static message - for Root Context"
```

### Test Health Checks
```bash
# From within VPC or with proper security group access:
curl http://<app1-instance-ip>/app1/index.html  # Should return 200-399
curl http://<app2-instance-ip>/app2/index.html  # Should return 200-399
curl http://<app3-instance-ip>:8080/login       # Should return 200-399
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| alb_name | Name for the Application Load Balancer | string | n/a | yes |
| vpc_id | VPC ID where the ALB will be created | string | n/a | yes |
| public_subnets | List of public subnet IDs for the ALB | list(string) | n/a | yes |
| loadbalancer_sg_id | Security group ID for the ALB | string | n/a | yes |
| certificate_arn | ARN of the ACM certificate for HTTPS | string | n/a | yes |
| dns_to_db_name | DNS name for DNS-to-DB ALB | string | "dns-to-db.myclick.agency" | no |
| ssl_policy | SSL policy for HTTPS listener | string | "ELBSecurityPolicy-TLS13-1-2-Res-2021-06" | no |
| enable_deletion_protection | Enable deletion protection | bool | false | no |
| target_group_1_name_prefix | Name prefix for target group 1 | string | "mtg1d-" | no |
| target_group_2_name_prefix | Name prefix for target group 2 | string | "mtg2d-" | no |
| target_group_3_name_prefix | Name prefix for target group 3 | string | "mtg3d-" | no |
| target_group_1_port | Port for target group 1 | number | 80 | no |
| target_group_2_port | Port for target group 2 | number | 80 | no |
| target_group_3_port | Port for target group 3 (UMS) | number | 8080 | no |
| target_group_protocol | Protocol for target groups | string | "HTTP" | no |
| protocol_version | Protocol version for target groups | string | "HTTP1" | no |
| deregistration_delay | Deregistration delay in seconds | number | 10 | no |
| app1_path_pattern | Path pattern for App1 routing | string | "/app1*" | no |
| app2_path_pattern | Path pattern for App2 routing | string | "/app2*" | no |
| app3_path_pattern | Path pattern for App3 routing | string | "/*" | no |
| app1_rule_priority | Priority for App1 routing rule | number | 10 | no |
| app2_rule_priority | Priority for App2 routing rule | number | 20 | no |
| app3_rule_priority | Priority for App3 routing rule | number | 30 | no |
| app1_health_check_path | Health check path for App1 | string | "/app1/index.html" | no |
| app2_health_check_path | Health check path for App2 | string | "/app2/index.html" | no |
| app3_health_check_path | Health check path for App3 | string | "/login" | no |
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
| alb_dnsdb_id | The ID of the load balancer |
| alb_dnsdb_arn | The ARN of the load balancer |
| alb_dnsdb_arn_suffix | ARN suffix for CloudWatch |
| alb_dnsdb_dns_name | The DNS name of the load balancer |
| alb_dnsdb_zone_id | The zone_id for DNS records |
| alb_dnsdb_listeners | Map of listeners (sensitive) |
| alb_dnsdb_listener_rules | Map of listener rules (sensitive) |
| alb_dnsdb_target_groups | Map of target groups |
| alb_dnsdb_target_group_1_arn | ARN of target group 1 (App1) |
| alb_dnsdb_target_group_2_arn | ARN of target group 2 (App2) |
| alb_dnsdb_target_group_3_arn | ARN of target group 3 (App3 UMS) |

## Dependencies

This module depends on:
- **VPC Module**: Provides vpc_id and public_subnets
- **SecurityGroups Module**: Provides loadbalancer_sg_id
- **ACM Module**: Provides certificate_arn for HTTPS
- **RDS Module**: Database for App3 (User Management System)

## Important Notes

1. **Target Attachments**: This module uses `create_attachment = false` for all target groups. Target attachments should be managed externally by Auto Scaling Groups or manual aws_lb_target_group_attachment resources.

2. **Routing Priority**: Rules are evaluated in order of priority (10, 20, 30). Lower numbers have higher priority. The catch-all pattern `/*` for App3 has the lowest priority (30) so specific paths are matched first.

3. **Port Configuration**: 
   - App1 and App2 run on port 80 (standard HTTP applications)
   - App3 (User Management System) runs on port 8080

4. **Default Action**: The fixed response is the default action when no routing rules match (e.g., accessing root `/` without any path).

5. **Stickiness**: Session stickiness is configured for 3600 seconds (1 hour) by default to maintain user sessions.

6. **Cross-Zone Load Balancing**: Disabled by default for cost optimization.

7. **Deregistration Delay**: Set to 10 seconds for faster deployments and connection draining.

8. **Health Checks**:
   - App1 and App2: Check standard index.html pages
   - App3: Checks `/login` endpoint (application-specific)

## User Management System (App3) Integration

The User Management System application on port 8080:
- Connects to RDS MySQL database for user data storage
- Provides user registration, login, and profile management
- Health check uses `/login` endpoint
- Handles all catch-all traffic (`/*`) that doesn't match App1 or App2 paths

### Database Connection
App3 instances should be configured with:
- RDS endpoint (from RDS module output)
- Database credentials (secure parameter store/secrets manager)
- Database name, username, and connection parameters

## Troubleshooting

### Traffic Not Routing Correctly
- Verify path patterns match your application URLs
- Check rule priorities (lower number = higher priority)
- Ensure target group health checks are passing
- Review ALB access logs for request patterns

### Health Checks Failing
- Verify health check paths exist on target instances
- Check security groups allow ALB to reach instances
- Confirm applications are listening on correct ports
  - App1/App2: Port 80
  - App3: Port 8080
- Review application logs for errors

### Session Issues
- Verify stickiness is enabled if session persistence needed
- Check stickiness duration is appropriate for your use case
- Consider application-level session management for multi-AZ

### App3 (UMS) Cannot Connect to Database
- Verify RDS security group allows access from App3 instances
- Check database endpoint and credentials configuration
- Ensure database is in same VPC as App3 instances
- Review application logs for database connection errors

## Cost Optimization

1. **Disable Deletion Protection**: Safe for non-production environments
2. **Adjust Health Check Intervals**: Increase interval for cost savings (trade-off: slower failure detection)
3. **Review Target Group Configuration**: Ensure only necessary targets are registered
4. **Monitor CloudWatch Metrics**: Track request patterns and optimize routing rules

## Security Considerations

1. **HTTPS Only**: All traffic is redirected to HTTPS
2. **TLS Policy**: Uses TLS 1.3 by default for strong encryption
3. **Security Groups**: ALB security group should restrict access appropriately
4. **Database Access**: App3 instances need proper security group rules to access RDS
5. **Secrets Management**: Use AWS Secrets Manager or Parameter Store for database credentials

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

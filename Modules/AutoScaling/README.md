# AutoScaling Module

## Overview
This module creates a complete AWS Auto Scaling Group infrastructure with launch templates, scaling policies, scheduled actions, and SNS notifications. It provides a production-ready setup for automatically scaling EC2 instances based on demand.

## Features
- **Launch Template**: Configurable EC2 launch template with encrypted EBS volumes
- **Auto Scaling Group**: Fully configurable ASG with health checks and lifecycle hooks
- **Target Tracking Scaling**: CPU-based automatic scaling
- **Scheduled Scaling**: Business hours capacity adjustments
- **SNS Notifications**: Email alerts for scaling events
- **Instance Refresh**: Rolling updates with minimum healthy percentage
- **Multi-AZ**: Distributes instances across multiple availability zones
- **Load Balancer Integration**: Supports both ALB and NLB target groups

## Architecture
```
Auto Scaling Group
├── Launch Template
│   ├── Encrypted EBS Volumes
│   ├── IMDSv2 Support
│   └── User Data Scripts
├── Scaling Policies
│   ├── Target Tracking (CPU)
│   └── Scheduled Actions
├── Lifecycle Hooks
│   ├── Launch Hook
│   └── Termination Hook
└── SNS Notifications
    └── Email Alerts
```

## Usage

### Basic Example
```hcl
module "autoscaling" {
  source = "../../Modules/AutoScaling"

  # Launch Template Configuration
  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = "t3.micro"
  instance_keypair  = "my-keypair"
  private_sg_id     = module.security_groups.private_sg_group_id
  user_data_script  = file("${path.module}/scripts/app-install.sh")

  # Launch Template Settings
  launch_template_name        = "myapp-dev-lt"
  launch_template_description = "Launch template for dev environment"

  # Auto Scaling Group Configuration
  private_subnets    = module.vpc.private_subnets
  target_group_arns  = [module.alb_basic.target_groups["mytg1"].arn]
  
  asg_name_prefix      = "myapp-dev-asg-"
  asg_desired_capacity = 2
  asg_max_size         = 10
  asg_min_size         = 2

  # Tags for instances
  lt_instance_tags = {
    Name        = "myapp-dev-instance"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }

  # ASG Tags with propagation
  asg_tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "myapp"
      propagate_at_launch = true
    }
  ]

  # SNS Notifications
  sns_email_endpoint = "devops@example.com"

  # Target Tracking Scaling Policy
  ttsp_cpu_target_value = 50.0

  # Scheduled Actions (disabled in dev)
  scheduled_action_increase_recurrence = ""  # Disable scheduled scaling
  scheduled_action_decrease_recurrence = ""
}
```

### Production Example (High Availability)
```hcl
module "autoscaling" {
  source = "../../Modules/AutoScaling"

  # Launch Template Configuration
  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = "t3.medium"
  instance_keypair  = "production-keypair"
  private_sg_id     = module.security_groups.private_sg_group_id
  user_data_script  = file("${path.module}/scripts/app-install.sh")

  launch_template_name        = "myapp-prod-lt"
  launch_template_description = "Production launch template"
  
  # Enhanced EBS Configuration
  root_volume_size      = 50
  root_volume_type      = "gp3"
  secondary_volume_size = 100
  secondary_volume_type = "gp3"
  ebs_encrypted         = true

  # IMDSv2 Required for production
  http_tokens = "required"

  # Auto Scaling Group Configuration
  private_subnets = module.vpc.private_subnets
  target_group_arns = concat(
    [module.alb_basic.target_groups["mytg1"].arn],
    [module.nlb.target_groups["mytg1"].arn]
  )

  asg_name_prefix            = "myapp-prod-asg-"
  asg_desired_capacity       = 4
  asg_max_size               = 20
  asg_min_size               = 4
  asg_health_check_type      = "ELB"  # Use load balancer health checks
  asg_health_check_grace_period = 600

  # Instance Tags
  lt_instance_tags = {
    Name        = "myapp-prod-instance"
    Environment = "production"
    Compliance  = "required"
    ManagedBy   = "Terraform"
  }

  # ASG Tags
  asg_tags = [
    {
      key                 = "Environment"
      value               = "production"
      propagate_at_launch = true
    },
    {
      key                 = "Backup"
      value               = "daily"
      propagate_at_launch = true
    }
  ]

  # SNS Notifications
  sns_email_endpoint = "prod-alerts@example.com"

  # Aggressive CPU-based scaling
  ttsp_cpu_target_value          = 60.0
  ttsp_estimated_instance_warmup = 300

  # Scheduled Actions for business hours
  scheduled_action_increase_name       = "increase-capacity-7am"
  scheduled_action_increase_min        = 4
  scheduled_action_increase_max        = 20
  scheduled_action_increase_desired    = 12
  scheduled_action_increase_recurrence = "00 07 * * MON-FRI"

  scheduled_action_decrease_name       = "decrease-capacity-10pm"
  scheduled_action_decrease_min        = 4
  scheduled_action_decrease_max        = 20
  scheduled_action_decrease_desired    = 4
  scheduled_action_decrease_recurrence = "00 22 * * *"

  # Instance Refresh Configuration
  instance_refresh_min_healthy_percentage = 75  # More conservative for production
}
```

### Spot Instances Example
```hcl
# Note: To enable Spot instances, uncomment the instance_market_options block in main.tf

module "autoscaling" {
  source = "../../Modules/AutoScaling"

  ami_id           = data.aws_ami.amazon_linux_2.id
  instance_type    = "t3.micro"
  instance_keypair = "my-keypair"
  private_sg_id    = module.security_groups.private_sg_group_id
  user_data_script = file("${path.module}/scripts/app-install.sh")

  # ... other configuration ...

  # After uncommenting instance_market_options in main.tf:
  # Set max_price in the Spot options block
}
```

## Inputs

### Launch Template Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami_id | AMI ID for instances | `string` | n/a | yes |
| instance_type | EC2 instance type | `string` | `"t3.micro"` | no |
| instance_keypair | Key pair name | `string` | n/a | yes |
| private_sg_id | Private security group ID | `string` | n/a | yes |
| user_data_script | User data script content | `string` | n/a | yes |
| launch_template_name | Launch template name | `string` | `"my-launch-template"` | no |
| root_volume_size | Root volume size (GB) | `number` | `20` | no |
| secondary_volume_size | Secondary volume size (GB) | `number` | `20` | no |
| ebs_encrypted | Encrypt EBS volumes | `bool` | `true` | no |
| http_tokens | IMDSv2 setting | `string` | `"optional"` | no |
| lt_instance_tags | Instance tags | `map(string)` | `{}` | no |

### Auto Scaling Group Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| private_subnets | Private subnet IDs | `list(string)` | n/a | yes |
| target_group_arns | Target group ARNs | `list(string)` | `[]` | no |
| asg_name_prefix | ASG name prefix | `string` | `"myasg-"` | no |
| asg_desired_capacity | Desired instance count | `number` | `2` | no |
| asg_max_size | Maximum instance count | `number` | `10` | no |
| asg_min_size | Minimum instance count | `number` | `2` | no |
| asg_health_check_type | Health check type | `string` | `"EC2"` | no |
| asg_tags | ASG tags with propagation | `list(object)` | `[]` | no |

### Scaling Policy Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ttsp_cpu_target_value | CPU target percentage | `number` | `50.0` | no |
| ttsp_estimated_instance_warmup | Warmup time (seconds) | `number` | `180` | no |

### SNS Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| sns_email_endpoint | Email for notifications | `string` | n/a | yes |

### Scheduled Action Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| scheduled_action_increase_desired | Desired capacity (morning) | `number` | `8` | no |
| scheduled_action_increase_recurrence | Cron expression | `string` | `"00 09 * * *"` | no |
| scheduled_action_decrease_desired | Desired capacity (evening) | `number` | `2` | no |
| scheduled_action_decrease_recurrence | Cron expression | `string` | `"00 21 * * *"` | no |

## Outputs

### Launch Template Outputs
| Name | Description |
|------|-------------|
| launch_template_id | Launch template ID |
| launch_template_arn | Launch template ARN |
| launch_template_latest_version | Latest version number |

### Auto Scaling Group Outputs
| Name | Description |
|------|-------------|
| autoscaling_group_id | ASG ID |
| autoscaling_group_name | ASG name |
| autoscaling_group_arn | ASG ARN |
| autoscaling_group_min_size | Minimum size |
| autoscaling_group_max_size | Maximum size |
| autoscaling_group_desired_capacity | Desired capacity |
| autoscaling_group_target_group_arns | Target group ARNs |

### SNS Outputs
| Name | Description |
|------|-------------|
| sns_topic_arn | SNS topic ARN |
| sns_topic_name | SNS topic name |

### Scaling Policy Outputs
| Name | Description |
|------|-------------|
| ttsp_cpu_policy_name | CPU policy name |
| ttsp_cpu_policy_arn | CPU policy ARN |

## Scaling Behavior

### Target Tracking Scaling (CPU)
- **Scale Out**: When average CPU > target value across all instances
- **Scale In**: When average CPU < target value
- **Warmup Period**: 180 seconds (configurable)
- **Cooldown**: Managed automatically by target tracking

### Scheduled Actions
- **Morning Scale-Up**: Increase capacity at 7 AM (default: to 8 instances)
- **Evening Scale-Down**: Decrease capacity at 5 PM (default: to 2 instances)
- **Cron Format**: UTC timezone, supports standard cron expressions

### Lifecycle Hooks
- **Launch Hook**: 60-second timeout for initialization tasks
- **Termination Hook**: 180-second timeout for cleanup tasks
- **Default Action**: CONTINUE (proceed with launch/termination)

## Instance Refresh
- **Strategy**: Rolling (replace instances gradually)
- **Min Healthy Percentage**: 50% (configurable)
- **Triggers**: Runs when desired_capacity changes
- **Use Case**: Safe deployment of launch template updates

## Security Best Practices

### IMDSv2 Configuration
```hcl
# Development
http_tokens = "optional"  # Allow both IMDSv1 and IMDSv2

# Production
http_tokens = "required"  # Require IMDSv2 only
```

### EBS Encryption
- All volumes encrypted by default
- Uses AWS-managed KMS keys
- Enable delete_on_termination for cleanup

### Health Checks
```hcl
# Development (faster feedback)
asg_health_check_type         = "EC2"
asg_health_check_grace_period = 300

# Production (load balancer aware)
asg_health_check_type         = "ELB"
asg_health_check_grace_period = 600
```

## Monitoring and Alerts

### SNS Notifications
Receive email alerts for:
- Instance launches
- Instance terminations
- Launch errors
- Termination errors

### CloudWatch Integration
The ASG automatically publishes metrics:
- GroupMinSize
- GroupMaxSize
- GroupDesiredCapacity
- GroupInServiceInstances
- GroupTotalInstances

## Troubleshooting

### Instances Not Launching
1. Check AMI ID is valid
2. Verify security group allows required traffic
3. Check subnet has available IP addresses
4. Review launch template user data for errors

### Scaling Not Working
1. Verify target tracking policy is active
2. Check CloudWatch metrics for CPU data
3. Ensure warmup period is appropriate
4. Review scaling activities in AWS Console

### Email Notifications Not Received
1. Confirm SNS subscription in email
2. Check spam folder
3. Verify email endpoint is correct

## Dependencies
- VPC module (for private_subnets)
- SecurityGroups module (for private_sg_id)
- ALB/NLB modules (optional, for target_group_arns)
- AMI data source (for ami_id)

## References
- [AWS Auto Scaling Documentation](https://docs.aws.amazon.com/autoscaling/)
- [Launch Templates Guide](https://docs.aws.amazon.com/autoscaling/ec2/userguide/launch-templates.html)
- [Target Tracking Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scaling-target-tracking.html)
- [Scheduled Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-scheduled-scaling.html)

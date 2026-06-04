# ALB-Attachments Module - Main Configuration
# Target group attachments for ALB custom routing, DNSDB, and host header configurations

################################################################################
# ALB Custom Routing - Target Group Attachments
################################################################################

# App1 pathbased instances to mytg1_customrouting
resource "aws_lb_target_group_attachment" "app1_customrouting" {
  for_each         = var.app1_pathbased_instance_ids
  target_group_arn = var.alb_customrouting_target_groups["mytg1_customrouting"].arn
  target_id        = each.value.id
  port             = 80
}

# App2 pathbased instances to mytg2_customrouting
resource "aws_lb_target_group_attachment" "app2_customrouting" {
  for_each         = var.app2_pathbased_instance_ids
  target_group_arn = var.alb_customrouting_target_groups["mytg2_customrouting"].arn
  target_id        = each.value.id
  port             = 80
}

################################################################################
# ALB DNSDB - Target Group Attachments
################################################################################

# App1 dnsdb instances to mytg1_dnsdb
resource "aws_lb_target_group_attachment" "app1_dnsdb" {
  count            = length(var.app1_dnsdb_instance_ids)
  target_group_arn = var.alb_dnsdb_target_groups["mytg1_dnsdb"].arn
  target_id        = var.app1_dnsdb_instance_ids[count.index]
  port             = 80
}

# App2 dnsdb instances to mytg2_dnsdb
resource "aws_lb_target_group_attachment" "app2_dnsdb" {
  count            = length(var.app2_dnsdb_instance_ids)
  target_group_arn = var.alb_dnsdb_target_groups["mytg2_dnsdb"].arn
  target_id        = var.app2_dnsdb_instance_ids[count.index]
  port             = 80
}

# App3 UMS instances to mytg3_dnsdb
resource "aws_lb_target_group_attachment" "app3_dnsdb" {
  count            = length(var.app3_ums_instance_ids)
  target_group_arn = var.alb_dnsdb_target_groups["mytg3_dnsdb"].arn
  target_id        = var.app3_ums_instance_ids[count.index]
  port             = 8080
}

################################################################################
# ALB Host Header - Target Group Attachments
################################################################################

# App1 pathbased instances to mytg1_hostheader
resource "aws_lb_target_group_attachment" "app1_hostheader" {
  for_each         = var.app1_pathbased_instance_ids
  target_group_arn = var.alb_hostheader_target_groups["mytg1_hostheader"].arn
  target_id        = each.value.id
  port             = 80
}

# App2 pathbased instances to mytg2_hostheader
resource "aws_lb_target_group_attachment" "app2_hostheader" {
  for_each         = var.app2_pathbased_instance_ids
  target_group_arn = var.alb_hostheader_target_groups["mytg2_hostheader"].arn
  target_id        = each.value.id
  port             = 80
}

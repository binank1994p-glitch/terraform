# ALB-Attachments Module - Variable Declarations
# Input variables required by the ALB Attachments module

variable "app1_pathbased_instance_ids" {
  description = "Map of app1 pathbased instance IDs and their details"
  type = map(object({
    id = string
  }))
}

variable "app2_pathbased_instance_ids" {
  description = "Map of app2 pathbased instance IDs and their details"
  type = map(object({
    id = string
  }))
}

variable "app1_dnsdb_instance_ids" {
  description = "List of app1 dnsdb instance IDs"
  type        = list(string)
}

variable "app2_dnsdb_instance_ids" {
  description = "List of app2 dnsdb instance IDs"
  type        = list(string)
}

variable "app3_ums_instance_ids" {
  description = "List of app3 UMS instance IDs"
  type        = list(string)
}

variable "alb_customrouting_target_groups" {
  description = "Map of customrouting target groups with their ARNs"
  type = map(object({
    arn = string
  }))
}

variable "alb_dnsdb_target_groups" {
  description = "Map of dnsdb target groups with their ARNs"
  type = map(object({
    arn = string
  }))
}

variable "alb_hostheader_target_groups" {
  description = "Map of hostheader target groups with their ARNs"
  type = map(object({
    arn = string
  }))
}

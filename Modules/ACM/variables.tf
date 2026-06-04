# Input variable definitions for ACM module

variable "domain_name" {
  description = "The primary domain name for the ACM certificate (e.g., myclick.agency)"
  type        = string
}

variable "subject_alternative_names" {
  description = "List of Subject Alternative Names (SANs) for the certificate (e.g., ['*.myclick.agency'])"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common tags to be applied to the ACM certificate"
  type        = map(string)
  default     = {}
}

variable "validation_method" {
  description = "Method to use for certificate validation. Valid values are DNS or EMAIL"
  type        = string
  default     = "DNS"

  validation {
    condition     = contains(["DNS", "EMAIL"], var.validation_method)
    error_message = "Validation method must be either 'DNS' or 'EMAIL'."
  }
}

variable "wait_for_validation" {
  description = "Whether to wait for the certificate to be validated. Set to false to avoid blocking"
  type        = bool
  default     = true
}

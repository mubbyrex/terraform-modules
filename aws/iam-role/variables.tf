variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "environment" {
  description = "Environment name (prod, test, etc.)"
  type        = string
}

variable "trust_relationships" {
  description = "List of trust relationships for assume role policy"
  type = list(object({
    principal_type = string
    identifiers    = list(string)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), [])
  }))
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds"
  type        = number
  default     = 3600
}

variable "description" {
  description = "Description of the IAM role"
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
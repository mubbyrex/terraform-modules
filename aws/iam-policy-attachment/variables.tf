variable "policy_name" {
  description = "Name of the policy"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "policy_document" {
  description = "Managed policy document (as a map/object)"
  type        = any
  default     = null
}

variable "inline_policy_document" {
  description = "Inline policy document (as a map/object)"
  type        = any
  default     = null
}

variable "role_id" {
  description = "ID of the role for inline policy attachment"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the policy"
  type        = string
  default     = ""
}

variable "path" {
  description = "Path for the policy"
  type        = string
  default     = "/"
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
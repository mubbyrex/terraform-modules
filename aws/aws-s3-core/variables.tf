###############################################################
# S3 Bucket Module — variables.tf
###############################################################

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket."
  type        = string

  validation {
  condition = (
    length(var.bucket_name) >= 3 &&
    length(var.bucket_name) <= 63 &&
    can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name)) &&
    !can(regex("\\.\\.", var.bucket_name)) && # no consecutive dots
    !can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", var.bucket_name)) # not an IP
  )

  error_message = "Bucket name must be 3-63 characters, lowercase, and follow S3 naming rules."
}
}

variable "force_destroy" {
  description = "If true, all objects are deleted when the bucket is destroyed."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable S3 object versioning."
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Block all public access to the bucket (recommended: true)."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN of a KMS key for SSE-KMS encryption. Leave null for AES-256."
  type        = string
  default     = null
}

variable "bucket_policy_json" {
  description = "JSON string of an IAM policy to attach to the bucket. Leave null to skip."
  type        = string
  default     = null
}

variable "logging_target_bucket" {
  description = "ID of the S3 bucket that receives access logs. Leave null to disable logging."
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefix for access log objects. Defaults to '<bucket_name>/'."
  type        = string
  default     = null
}

variable "lifecycle_rules" {
  description = <<-EOT
    List of lifecycle rules. Each rule supports:
      - id                              (string, required)
      - enabled                         (bool,   required)
      - prefix                          (string, optional) — filter by object prefix
      - transitions                     (list,   optional) — list of { days, storage_class }
      - expiration_days                 (number, optional)
      - noncurrent_version_expiration_days (number, optional)
  EOT
  type        = any
  default     = []
}

variable "cors_rules" {
  description = <<-EOT
    List of CORS rules. Each rule supports:
      - allowed_methods (list, required) — e.g. ["GET","PUT"]
      - allowed_origins (list, required) — e.g. ["https://example.com"]
      - allowed_headers (list, optional) — default ["*"]
      - expose_headers  (list, optional)
      - max_age_seconds (number, optional) — default 3000
  EOT
  type        = any
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}
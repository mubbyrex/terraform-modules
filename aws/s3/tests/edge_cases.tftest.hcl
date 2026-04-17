# Versioning disabled but encryption enabled

run "validate_bucket_configuration" {
  command = plan

  variables {
    bucket_name        = "my-valid-bucket-123"
    force_destroy      = false
    versioning_enabled = false

    kms_key_arn        = null
    block_public_access = true

    tags = {
      Environment = "dev"
    }

    lifecycle_rules = []
    cors_rules      = []
    bucket_policy_json = null
    logging_target_bucket = null
    logging_target_prefix = null
  }

  assert {
    condition = alltrue([
        aws_s3_bucket.this.bucket == var.bucket_name,
        aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Suspended",
        aws_s3_bucket_public_access_block.this.block_public_acls == var.block_public_access,
        aws_s3_bucket_public_access_block.this.block_public_policy == var.block_public_access,
        aws_s3_bucket_public_access_block.this.ignore_public_acls == var.block_public_access,
        aws_s3_bucket_public_access_block.this.restrict_public_buckets == var.block_public_access
    ])

    error_message = "Expected bucket configuration to match the provided variables"
  }
}
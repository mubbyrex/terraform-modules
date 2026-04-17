run "validate_bucket_encryption" {
  command = plan

  variables {
    bucket_name        = "my-valid-bucket-123"
    force_destroy      = false
    versioning_enabled = true

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
    condition = anytrue([
        for r in aws_s3_bucket_server_side_encryption_configuration.this.rule :
        r.apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    ])

    error_message = "Expected AES256 encryption to be enabled"
    }
}
# terraform-s3-module

A reusable local Terraform module for provisioning AWS S3 buckets with sensible, secure defaults.

---

## Directory structure

```
terraform-s3-module/
├── main.tf              ← root: three example bucket usages
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── modules/
    └── s3_bucket/
        ├── main.tf      ← all S3 resources
        ├── variables.tf ← every knob you can turn
        └── outputs.tf   ← bucket id, arn, domain names
```

---

## Quick start

```bash
cd terraform-s3-module
terraform init
terraform plan
terraform apply
```

---

## Module reference

### Source path
```hcl
source = "./modules/s3_bucket"
```

### Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `bucket_name` | `string` | **required** | Globally unique bucket name |
| `force_destroy` | `bool` | `false` | Delete all objects on `destroy` |
| `versioning_enabled` | `bool` | `false` | Enable object versioning |
| `block_public_access` | `bool` | `true` | Block all public access |
| `kms_key_arn` | `string` | `null` | KMS key ARN for SSE-KMS (null → AES-256) |
| `bucket_policy_json` | `string` | `null` | Raw IAM policy JSON to attach |
| `logging_target_bucket` | `string` | `null` | Bucket ID to receive access logs |
| `logging_target_prefix` | `string` | `null` | Log object prefix (default: `<bucket_name>/`) |
| `lifecycle_rules` | `any` | `[]` | List of lifecycle rule objects (see below) |
| `cors_rules` | `any` | `[]` | List of CORS rule objects (see below) |
| `tags` | `map(string)` | `{}` | Extra tags applied to all resources |

### Outputs

| Name | Description |
|---|---|
| `bucket_id` | Bucket name / ID |
| `bucket_arn` | Full ARN |
| `bucket_domain_name` | `<bucket>.s3.amazonaws.com` |
| `bucket_regional_domain_name` | Regional domain (use for CloudFront) |
| `bucket_region` | AWS region |

---

## Lifecycle rule schema

```hcl
lifecycle_rules = [
  {
    id      = "archive-old-objects"   # (string) required
    enabled = true                    # (bool)   required
    prefix  = "archive/"              # (string) optional — filter by key prefix

    transitions = [                   # optional
      { days = 30,  storage_class = "STANDARD_IA" },
      { days = 90,  storage_class = "GLACIER" },
      { days = 365, storage_class = "DEEP_ARCHIVE" },
    ]

    expiration_days                    = 730  # optional
    noncurrent_version_expiration_days = 90   # optional
  }
]
```

Valid `storage_class` values: `STANDARD_IA`, `ONEZONE_IA`, `INTELLIGENT_TIERING`, `GLACIER`, `DEEP_ARCHIVE`, `GLACIER_IR`.

---

## CORS rule schema

```hcl
cors_rules = [
  {
    allowed_methods = ["GET", "HEAD"]            # required
    allowed_origins = ["https://example.com"]    # required
    allowed_headers = ["*"]                      # optional, default ["*"]
    expose_headers  = ["ETag"]                   # optional
    max_age_seconds = 86400                      # optional, default 3000
  }
]
```

---

## Examples

### Minimal private bucket
```hcl
module "logs" {
  source      = "./modules/s3_bucket"
  bucket_name = "my-app-logs"
}
```

### Versioned bucket with lifecycle rules
```hcl
module "data" {
  source             = "./modules/s3_bucket"
  bucket_name        = "my-app-data"
  versioning_enabled = true

  lifecycle_rules = [
    {
      id              = "expire-tmp"
      enabled         = true
      prefix          = "tmp/"
      expiration_days = 7
    }
  ]
}
```

### Static-site bucket (public read)
```hcl
module "site" {
  source              = "./modules/s3_bucket"
  bucket_name         = "my-app-site"
  block_public_access = false

  cors_rules = [
    {
      allowed_methods = ["GET"]
      allowed_origins = ["https://example.com"]
    }
  ]

  bucket_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "arn:aws:s3:::my-app-site/*"
    }]
  })
}
```
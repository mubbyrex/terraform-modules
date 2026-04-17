# aws-iam-policy

A reusable Terraform module for provisioning AWS IAM policies and attaching inline policies to a role.

This module is built for shared use across projects that need a consistent policy structure. It supports creating a managed policy from a policy document, attaching an inline policy to an existing role, or both when needed.

---

## Quick start

```bash
cd aws/iam-policy
terraform init
terraform plan
terraform apply
```

---

## Module reference

### Source path

```hcl
source = "./aws/iam-policy"
```

### Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `policy_name` | `string` | **required** | Name of the managed policy and inline policy prefix |
| `environment` | `string` | **required** | Environment identifier such as `prod`, `dev`, or `test` |
| `policy_document` | `any` | `null` | Managed policy document represented as a map/object; when set, a managed policy is created |
| `inline_policy_document` | `any` | `null` | Inline policy document represented as a map/object; when set, it is attached to the role identified by `role_id` |
| `role_id` | `string` | `""` | ID of the IAM role to attach the inline policy to |
| `description` | `string` | `""` | Optional description for the managed policy |
| `path` | `string` | `/` | IAM path for the managed policy |
| `common_tags` | `map(string)` | `{}` | Tags applied to the managed policy |

### Outputs

| Name | Description |
|---|---|
| `policy_arn` | ARN of the custom managed policy, if created |
| `policy_name` | Name of the custom managed policy, if created |

---

## Behavior

- If `policy_document` is provided, the module creates an AWS managed policy.
- If `inline_policy_document` is provided and `role_id` is set, the module attaches an inline policy to the specified role.
- Both managed and inline policy creation can be used together.

---

## Examples

### Create a managed IAM policy

```hcl
module "example_policy" {
  source = "./aws/iam-policy"

  policy_name     = "example-managed-policy"
  environment     = "prod"
  description     = "Managed policy for service access"
  path            = "/service/"
  common_tags = {
    Project = "example-app"
    Owner   = "team-ops"
  }

  policy_document = {
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:ListBucket"]
        Effect   = "Allow"
        Resource = ["arn:aws:s3:::example-bucket"]
      }
    ]
  }
}
```

### Attach an inline policy to a role

```hcl
module "inline_role_policy" {
  source = "./aws/iam-policy"

  policy_name           = "example-inline-policy"
  environment           = "dev"
  role_id               = aws_iam_role.example.id
  inline_policy_document = {
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ec2:DescribeInstances"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  }
}
```

### Create a managed policy and attach an inline policy at the same time

```hcl
module "policy_and_inline" {
  source = "./aws/iam-policy"

  policy_name            = "example-policy"
  environment            = "staging"
  description            = "Policy package for staging"
  role_id                = aws_iam_role.example.id
  policy_document = {
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject"]
        Effect   = "Allow"
        Resource = ["arn:aws:s3:::example-bucket/*"]
      }
    ]
  }
  inline_policy_document = {
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sts:AssumeRole"]
        Effect   = "Allow"
        Resource = "arn:aws:iam::123456789012:role/example-trust-role"
      }
    ]
  }
}
```

---

## Notes

- Provide `policy_document` to create a managed policy.
- Provide `inline_policy_document` and `role_id` to attach a policy directly to a role.
- `common_tags` are applied to the managed policy only.
- Use `policy_arn` output when you need to reference the managed policy elsewhere.

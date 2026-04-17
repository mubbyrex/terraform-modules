# aws-iam-role

A reusable Terraform module for provisioning an AWS IAM role with structured trust relationships and common tag support.

This module is designed for use across multiple projects where a consistent IAM role pattern is needed. It builds a role from a set of trusted principals and lets you manage session duration, metadata, and tags in one place.

---

## Quick start

```bash
cd aws/iam-role
terraform init
terraform plan
terraform apply
```

---

## Module reference

### Source path

```hcl
source = "./aws/iam-role"
```

### Inputs

| Name                   | Type                                                                                                                                                                          | Default      | Description                                                   |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | ------------------------------------------------------------- |
| `role_name`            | `string`                                                                                                                                                                      | **required** | Name of the IAM role                                          |
| `environment`          | `string`                                                                                                                                                                      | **required** | Environment identifier such as `prod`, `dev`, or `test`       |
| `trust_relationships`  | `list(object({ principal_type = string, identifiers = list(string), conditions = optional(list(object({ test = string, variable = string, values = list(string) })), []) }))` | **required** | Trust relationships used to build the assume role policy      |
| `max_session_duration` | `number`                                                                                                                                                                      | `3600`       | Maximum allowed session duration in seconds                   |
| `description`          | `string`                                                                                                                                                                      | `""`         | Optional role description                                     |
| `common_tags`          | `map(string)`                                                                                                                                                                 | `{}`         | Tags added to the IAM role, merged with default metadata tags |

### Outputs

| Name        | Description                  |
| ----------- | ---------------------------- |
| `role_arn`  | ARN of the created IAM role  |
| `role_name` | Name of the created IAM role |
| `role_id`   | ID of the created IAM role   |

---

## Trust relationship schema

Provide one or more trust relationship objects to define who can assume the role.

```hcl
trust_relationships = [
  {
    principal_type = "Service"
    identifiers    = ["ec2.amazonaws.com"]
    conditions = [
      {
        test     = "StringEquals"
        variable = "sts:ExternalId"
        values   = ["example-external-id"]
      }
    ]
  }
]
```

Each trust relationship entry includes:

- `principal_type`: The principal type, such as `Service`, `AWS`, or `Federated`
- `identifiers`: A list of principal identifiers for the trust policy
- `conditions`: Optional list of condition objects to restrict the assume role policy

Condition objects include:

- `test`: Condition operator, for example `StringEquals` or `StringLike`
- `variable`: Condition key used in the trust policy
- `values`: List of allowed values for the condition

---

## Example usage

### Basic IAM role for EC2

```hcl
module "example_role" {
  source = "./aws/iam-role"

  role_name           = "example-ec2-role"
  environment         = "prod"
  max_session_duration = 3600
  description         = "Role for EC2 instances to assume"

  trust_relationships = [
    {
      principal_type = "Service"
      identifiers    = ["ec2.amazonaws.com"]
      conditions     = []
    }
  ]

  common_tags = {
    Project = "example-app"
    Owner   = "team-ops"
  }
}
```

### IAM role with a federated identity provider

```hcl
module "federated_role" {
  source = "./aws/iam-role"

  role_name   = "example-federated-role"
  environment = "dev"
  description = "Role assumed by an external identity provider"

  trust_relationships = [
    {
      principal_type = "Federated"
      identifiers    = ["arn:aws:iam::123456789012:saml-provider/MyProvider"]
      conditions = [
        {
          test     = "StringEquals"
          variable = "SAML:aud"
          values   = ["https://signin.aws.amazon.com/saml"]
        }
      ]
    }
  ]
}
```

---

## Notes

- The module creates the assume role policy from the `trust_relationships` list.
- `common_tags` are merged with role metadata, including `Name`, `Environment`, and `ManagedBy`.
- Use `role_arn` or `role_id` output values to attach inline policies, managed policies, or role attachments in other modules.

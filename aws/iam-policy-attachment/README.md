# aws-iam-policy-attachment

A reusable Terraform module for attaching AWS managed policies to IAM roles or users.

This module simplifies policy management across projects by providing a consistent way to attach existing managed policies to roles or users, ensuring proper access control without duplicating policy definitions.

---

## Quick start

```bash
cd aws/iam-policy-attachment
terraform init
terraform plan
terraform apply
```

---

## Module reference

### Source path

```hcl
source = "./aws/iam-policy-attachment"
```

### Inputs

| Name          | Type     | Default      | Description                                                                     |
| ------------- | -------- | ------------ | ------------------------------------------------------------------------------- |
| `role_id`     | `string` | `""`         | ID of the IAM role to attach the policy to (leave empty if attaching to a user) |
| `user_id`     | `string` | `""`         | ID of the IAM user to attach the policy to (leave empty if attaching to a role) |
| `policy_arn`  | `string` | **required** | ARN of the managed policy to attach                                             |
| `environment` | `string` | **required** | Environment identifier such as `prod`, `dev`, or `test`                         |

### Outputs

| Name            | Description                 |
| --------------- | --------------------------- |
| `attachment_id` | ID of the policy attachment |

---

## Behavior

- The module attaches a managed policy to either a role or a user, but not both.
- Provide `role_id` to attach to a role, or `user_id` to attach to a user.
- The `policy_arn` must be the ARN of an existing managed policy.

---

## Example usage

### Attach a managed policy to a role

```hcl
module "role_policy_attachment" {
  source = "./aws/iam-policy-attachment"

  role_id     = aws_iam_role.example.id
  policy_arn  = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  environment = "prod"
}
```

### Attach a managed policy to a user

```hcl
module "user_policy_attachment" {
  source = "./aws/iam-policy-attachment"

  user_id     = aws_iam_user.example.name
  policy_arn  = "arn:aws:iam::aws:policy/AdministratorAccess"
  environment = "dev"
}
```

---

## Notes

- Ensure the policy ARN exists and is accessible in your AWS account.
- Use this module to attach AWS managed policies or your own custom managed policies.
- The attachment is created only if both the target (role or user) and policy ARN are provided.
- For inline policies, consider using the `aws-iam-policy` module instead.

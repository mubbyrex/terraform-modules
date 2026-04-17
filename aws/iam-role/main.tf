resource "aws_iam_role" "this" {
  name                 = "${var.role_name}"
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = var.max_session_duration
  description          = var.description

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.role_name}"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

data "aws_iam_policy_document" "trust" {
  dynamic "statement" {
    for_each = var.trust_relationships
    content {
      effect = "Allow"
      principals {
        type        = statement.value.principal_type
        identifiers = statement.value.identifiers
      }
      actions = ["sts:AssumeRole"]
      dynamic "condition" {
        for_each = statement.value.conditions != null ? statement.value.conditions : []
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}
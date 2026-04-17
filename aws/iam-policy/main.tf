resource "aws_iam_policy" "custom" {
  count       = var.policy_document != null ? 1 : 0
  name        = "${var.policy_name}"
  description = var.description
  policy      = data.aws_iam_policy_document.policy[0].json
  path        = var.path
  tags        = var.common_tags
}

data "aws_iam_policy_document" "policy" {
  count = var.policy_document != null ? 1 : 0

  source_policy_documents = [
    jsonencode(var.policy_document)
  ]
}

resource "aws_iam_role_policy" "inline" {
  count  = var.inline_policy_document != null ? 1 : 0
  name   = "${var.policy_name}-inline"
  role   = var.role_id
  policy = data.aws_iam_policy_document.inline_policy[0].json
}

data "aws_iam_policy_document" "inline_policy" {
  count = var.inline_policy_document != null ? 1 : 0

  source_policy_documents = [
    jsonencode(var.inline_policy_document)
  ]
}
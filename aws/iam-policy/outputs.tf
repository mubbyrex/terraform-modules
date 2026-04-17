output "policy_arn" {
  description = "ARN of the custom managed policy"
  value       = try(aws_iam_policy.custom[0].arn, "")
}

output "policy_name" {
  description = "Name of the custom managed policy"
  value       = try(aws_iam_policy.custom[0].name, "")
}
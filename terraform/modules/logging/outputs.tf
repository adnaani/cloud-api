output "log_group_name" {
  description = "Log group name."
  value       = aws_cloudwatch_log_group.cloud_api.name
}

output "log_group_arn" {
  description = "Log group arn."
  value       = aws_cloudwatch_log_group.cloud_api.arn
}

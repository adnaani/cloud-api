output "execution_role_arn" {
  description = "Execution role arn."
  value       = aws_iam_role.ecs_execution.arn
}

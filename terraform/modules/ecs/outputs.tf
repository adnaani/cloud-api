output "cluster_arn" {
  description = "ARN of the ECS cluster."
  value       = aws_ecs_cluster.cloud_api.arn
}

output "task_definition_arn" {
  description = "ARN of the registered task definition revision."
  value       = aws_ecs_task_definition.cloud_api.arn
}

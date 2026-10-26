output "ecr_repository_url" {
  description = "URL of the Cloud API ECR repository"
  value       = aws_ecr_repository.cloud_api.repository_url
}
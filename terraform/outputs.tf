output "ecr_repository_url" {
  description = "URL of the Cloud API ECR repository"
  value       = module.ecr.repository_url
}

output "api_url" {
  description = "Public HTTP URL of the Cloud API."
  value       = "http://${module.alb.dns_name}"
}
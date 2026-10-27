resource "aws_ecs_cluster" "cloud_api" {
  name = "cloud-api-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Name        = "cloud-api-cluster"
    Environment = var.environment
    Project     = "cloud-api"
    ManagedBy   = "terraform"
  }
}
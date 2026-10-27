resource "aws_cloudwatch_log_group" "cloud_api" {
  name              = "/ecs/cloud-api"
  retention_in_days = 7

  tags = {
    Name        = "cloud-api-logs"
    Environment = var.environment
    Project     = "cloud-api"
    ManagedBy   = "terraform"
  }
}

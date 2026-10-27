resource "aws_ecr_repository" "cloud_api" {
  name                 = "cloud-api"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "cloud-api"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

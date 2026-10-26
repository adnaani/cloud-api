resource "aws_vpc" "cloud_api" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "cloud-api-vpc"
    Environment = var.environment
    Project     = "cloud-api"
    ManagedBy   = "terraform"
  }
}

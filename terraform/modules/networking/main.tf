resource "aws_vpc" "cloud_api" {
  cidr_block           = var.vpc_cidr
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

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.cloud_api.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true

  tags = {
    Name        = "cloud-api-public-a"
    Environment = var.environment
    Project     = "cloud-api"
    ManagedBy   = "terraform"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.cloud_api.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true

  tags = {
    Name        = "cloud-api-public-b"
    Environment = var.environment
    Project     = "cloud-api"
    ManagedBy   = "terraform"
  }
}

resource "aws_internet_gateway" "cloud_api" {
  vpc_id = aws_vpc.cloud_api.id

  tags = {
    Name        = "cloud-api-igw"
    Environment = var.environment
    Project     = "cloud-api"
    ManagedBy   = "terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cloud_api.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloud_api.id
  }

  tags = {
    Name        = "cloud-api-public-rt"
    Environment = var.environment
    Project     = "cloud-api"
    ManagedBy   = "terraform"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}


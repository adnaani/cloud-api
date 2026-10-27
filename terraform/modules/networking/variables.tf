variable "environment" {
  description = "The environment for the resources (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "The CIDR block for the public subnet in availability zone A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "The CIDR block for the public subnet in availability zone B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone_a" {
  description = "The availability zone for the public subnet A"
  type        = string
  default     = "eu-west-2a"
}

variable "availability_zone_b" {
  description = "The availability zone for the public subnet B"
  type        = string
  default     = "eu-west-2b"
}

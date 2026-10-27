variable "environment" {
  description = "Environment label for resource tags."
  type        = string
}
variable "vpc_id" {
  type        = string
  description = "VPC containing the security groups."
}

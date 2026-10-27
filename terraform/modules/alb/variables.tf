variable "environment" {
  description = "Environment label for resource tags."
  type        = string
}
variable "vpc_id" {
  type        = string
  description = "VPC containing the target group."
}
variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets in two Availability Zones."
}
variable "security_group_id" {
  type        = string
  description = "Security group for the load balancer."
}

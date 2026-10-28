variable "environment" {
  description = "Environment label for ECS resource tags."
  type        = string
}

variable "ecs_task_cpu" {
  description = "CPU units for the ECS task."
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "Memory (in MiB) for the ECS task."
  type        = number
  default     = 512
}

variable "cloud_api_image" {
  description = "Docker image for the Cloud API container."
  type        = string
}

variable "cloud_api_container_port" {
  description = "Port for the Cloud API container."
  type        = number
  default     = 3000
}
variable "execution_role_arn" {
  description = "IAM execution role used for image pulls and logging."
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group for container output."
  type        = string
}

variable "aws_region" {
  description = "Region containing the CloudWatch log group."
  type        = string
  default     = "eu-west-2"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ECS service."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for the ECS service."
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group for the ECS service."
  type        = string
}
output "alb_security_group_id" {
  description = "Alb security group id."
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "Ecs security group id."
  value       = aws_security_group.ecs.id
}

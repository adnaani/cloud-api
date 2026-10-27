output "arn" {
  description = "Arn."
  value       = aws_lb.cloud_api.arn
}

output "dns_name" {
  description = "Dns name."
  value       = aws_lb.cloud_api.dns_name
}

output "target_group_arn" {
  description = "Target group arn."
  value       = aws_lb_target_group.cloud_api.arn
}

output "listener_arn" {
  description = "Listener arn."
  value       = aws_lb_listener.http.arn
}

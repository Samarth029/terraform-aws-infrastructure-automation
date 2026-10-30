output "app_security_group_id" {
  description = "Security group ID of the application instances"
  value       = aws_security_group.app.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  description = "ID of the application launch template"
  value       = aws_launch_template.app.id
}
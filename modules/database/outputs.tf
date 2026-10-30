output "database_endpoint" {
  description = "Endpoint address of the RDS database"
  value       = aws_db_instance.main.address
}

output "database_port" {
  description = "Port used by the RDS database"
  value       = aws_db_instance.main.port
}

output "database_security_group_id" {
  description = "Security group ID of the RDS database"
  value       = aws_security_group.database.id
}

output "database_arn" {
  description = "ARN of the RDS database"
  value       = aws_db_instance.main.arn
}
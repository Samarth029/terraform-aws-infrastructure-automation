
output "web_instance_id" {
  description = "ID of the EC2 web server"
  value       = aws_instance.web.id
}

output "web_public_ip" {
  description = "Public IPv4 address of the EC2 web server"
  value       = aws_instance.web.public_ip
}

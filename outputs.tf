
output "vpc_id" {
  description = "ID of the main VPC"
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID of the first public subnet"
  value       = module.network.public_subnet_id
}

output "public_subnet_b_id" {
  description = "ID of the second public subnet"
  value       = module.network.public_subnet_b_id
}

output "private_subnet_a_id" {
  description = "ID of the first private subnet"
  value       = module.network.private_subnet_a_id
}

output "private_subnet_b_id" {
  description = "ID of the second private subnet"
  value       = module.network.private_subnet_b_id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.network.internet_gateway_id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.network.public_route_table_id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = module.network.private_route_table_id
}

output "web_security_group_id" {
  description = "ID of the security group for the public web server"
  value       = module.security.web_security_group_id
}

output "web_instance_id" {
  description = "ID of the EC2 web server"
  value       = module.compute.web_instance_id
}

output "web_public_ip" {
  description = "Public IPv4 address of the EC2 web server"
  value       = module.compute.web_public_ip
}

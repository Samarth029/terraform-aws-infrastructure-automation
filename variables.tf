
variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
  default     = "terraform-aws-infra"
}

variable "aws_region" {
  description = "AWS region for deploying resources"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "notification_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
}
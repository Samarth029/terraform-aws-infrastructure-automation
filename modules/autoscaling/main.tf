variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID of the Application Load Balancer"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for Auto Scaling instances"
  type        = string
  default     = "t3.micro"
}

# Security group for application instances
resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Allow application traffic only from the ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP traffic from the ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-app-sg"
    Project = var.project_name
  }
}

# Launch template for Auto Scaling instances
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-app-"
  image_id      = "ami-04394a3a96907e9ec"
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd

    echo "<h1>Terraform Auto Scaling Application</h1>" > /var/www/html/index.html
  EOF
  )

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "${var.project_name}-app-instance"
      Project = var.project_name
    }
  }
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for Auto Scaling instances"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  name                = "${var.project_name}-asg"
  min_size            = 1
  desired_capacity    = 1
  max_size            = 2
  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = [var.target_group_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 180

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }
}

variable "notification_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
}

variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

variable "security_group_id" {
  description = "ID of the web security group"
  type        = string
}

resource "aws_instance" "web" {
  ami                         = "ami-04394a3a96907e9ec"
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  iam_instance_profile        = "EC2-SSM-Role"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  # Preserve the original user_data exactly.
  user_data = <<-EOF
#!/bin/bash
dnf install -y httpd
systemctl enable --now httpd

cat > /var/www/html/index.html <<'HTML'
<!DOCTYPE html>
<html>
  <head><title>Terraform AWS Web Server</title></head>
  <body>
    <h1>Hello from AWS EC2!</h1>
    <p>This web server was deployed using Terraform.</p>
  </body>
</html>
HTML
EOF

  user_data_replace_on_change = false

  tags = {
    Name    = "${var.project_name}-web-server"
    Project = var.project_name
  }
}

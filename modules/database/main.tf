
variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the RDS database"
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group ID of the application instances"
  type        = string
}

variable "db_name" {
  description = "Name of the application database"
  type        = string
  default     = "appdb"
}

# AWS-managed KMS key for RDS storage encryption
data "aws_kms_key" "rds" {
  key_id = "alias/aws/rds"
}

# AWS-managed KMS key for Secrets Manager encryption
data "aws_kms_key" "secretsmanager" {
  key_id = "alias/aws/secretsmanager"
}

# Security group for RDS
resource "aws_security_group" "database" {
  name        = "${var.project_name}-database-sg"
  description = "Allow MySQL access only from application instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow MySQL from application instances"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  # No outbound rules required for this database security group
  egress = []

  tags = {
    Name    = "${var.project_name}-database-sg"
    Project = var.project_name
  }
}

# DB subnet group using existing private subnets
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name    = "${var.project_name}-db-subnet-group"
    Project = var.project_name
  }
}

# RDS MySQL database
resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-mysql"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = "dbadmin"

  manage_master_user_password   = true
  master_user_secret_kms_key_id = data.aws_kms_key.secretsmanager.arn

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database.id]

  publicly_accessible = false
  multi_az            = false
  storage_encrypted   = true
  kms_key_id          = data.aws_kms_key.rds.arn

  backup_retention_period    = 1
  auto_minor_version_upgrade = true

  deletion_protection       = true
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.project_name}-final-snapshot"

  copy_tags_to_snapshot = true

  tags = {
    Name    = "${var.project_name}-mysql"
    Project = var.project_name
  }
}

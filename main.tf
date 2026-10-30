
module "network" {
  source       = "./modules/network"
  project_name = var.project_name
  aws_region   = var.aws_region
}

module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
}

module "load_balancer" {
  source       = "./modules/load_balancer"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id

  public_subnet_ids = [
    module.network.public_subnet_id,
    module.network.public_subnet_b_id
  ]
}

module "autoscaling" {
  source       = "./modules/autoscaling"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id

  alb_security_group_id = module.load_balancer.alb_security_group_id

  instance_type = var.instance_type

  public_subnet_ids = [
    module.network.public_subnet_id,
    module.network.public_subnet_b_id
  ]

  target_group_arn   = module.load_balancer.target_group_arn
  notification_email = var.notification_email
}

module "database" {
  source       = "./modules/database"
  project_name = var.project_name

  vpc_id = module.network.vpc_id

  private_subnet_ids = [
    module.network.private_subnet_a_id,
    module.network.private_subnet_b_id
  ]

  app_security_group_id = module.autoscaling.app_security_group_id

  db_name = "appdb"
}

module "compute" {
  source            = "./modules/compute"
  project_name      = var.project_name
  instance_type     = var.instance_type
  subnet_id         = module.network.public_subnet_id
  security_group_id = module.security.web_security_group_id
}

# Preserve existing Terraform resource identities during refactoring.
moved {
  from = aws_vpc.main
  to   = module.network.aws_vpc.main
}

moved {
  from = aws_internet_gateway.main
  to   = module.network.aws_internet_gateway.main
}

moved {
  from = aws_subnet.public
  to   = module.network.aws_subnet.public
}

moved {
  from = aws_subnet.public_b
  to   = module.network.aws_subnet.public_b
}

moved {
  from = aws_subnet.private_a
  to   = module.network.aws_subnet.private_a
}

moved {
  from = aws_subnet.private_b
  to   = module.network.aws_subnet.private_b
}

moved {
  from = aws_route_table.public
  to   = module.network.aws_route_table.public
}

moved {
  from = aws_route_table.private
  to   = module.network.aws_route_table.private
}

moved {
  from = aws_route_table_association.public
  to   = module.network.aws_route_table_association.public
}

moved {
  from = aws_route_table_association.public_b
  to   = module.network.aws_route_table_association.public_b
}

moved {
  from = aws_route_table_association.private_a
  to   = module.network.aws_route_table_association.private_a
}

moved {
  from = aws_route_table_association.private_b
  to   = module.network.aws_route_table_association.private_b
}

moved {
  from = aws_security_group.web
  to   = module.security.aws_security_group.web
}

moved {
  from = aws_instance.web
  to   = module.compute.aws_instance.web
}

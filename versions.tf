
terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket       = "terraform-aws-infra-state-962942593569-ap-south-1"
    key          = "terraform-aws-infrastructure-automation/terraform.tfstate"
    region       = "ap-south-1"
    profile      = "terraform-dev"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

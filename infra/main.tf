# Main Terraform configuration for Blue-Green Deployment System

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  # backend "s3" {}  # Uncomment and configure for remote state
}

provider "aws" {
  region = var.aws_region
}

# module "vpc" {
#   source = "./modules/vpc"
#   ...
# }

# module "alb" {
#   source = "./modules/alb"
#   ...
# }

# module "ecs" {
#   source = "./modules/ecs-service"
#   ...
# }

# module "route53" {
#   source = "./modules/route53"
#   ...
# }

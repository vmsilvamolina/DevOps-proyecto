terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "bucket-stockwiz-tf"
    key    = "root/terraform.tfstate"      # la ruta + nombre del archivo dentro del bucket
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  environment          = var.environment
}

# ECR
module "ecr" {
  source = "./modules/ecr"
  ecr_repositories = var.ecr_repositories
}

# Security Groups (creates both alb and ecs SGs)
module "security_group" {
  source          = "./modules/security-group"
  vpc_id          = module.vpc.vpc_id
  vpc_cidr        = var.vpc_cidr
  environment     = var.environment
  api_gateway_port = var.apigateway_port
}

# ALB (depends on security_group, uses the alb_sg_id)
module "alb" {
  source            = "./modules/alb"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_group.alb_sg_id
  apigateway_port   = var.apigateway_port
}

# ECS Cluster
module "ecs_cluster" {
  source      = "./modules/ecs-cluster"
  environment = var.environment
}


module "ecs_service_core" {
  source            = "./modules/ecs-service"
  environment       = var.environment
  service_name      = "${var.environment}-core-service"
  cluster_id        = module.ecs_cluster.cluster_id
  task_definition_arn = ""
  desired_count     = 0
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = module.security_group.ecs_sg_id
  assign_public_ip  = true
  target_group_arn  = module.alb.target_group_arn
  aws_region        = var.aws_region
  ecr_product_url   = module.ecr.ecr_urls["product"]
  ecr_inventory_url = module.ecr.ecr_urls["inventory"]
  ecr_api_url       = module.ecr.ecr_urls["apigateway"]
}

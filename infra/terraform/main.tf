terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "bucket-tf"
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
  private_subnet_cidrs = var.private_subnet_cidrs
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
  service_name      = "${var.environment}-core-service"   # service único que correrá las 5 containers cuando pipeline lo actualice
  cluster_id        = module.ecs_cluster.cluster_id
  task_definition_arn = ""   # vacío por ahora (pipeline registrará y hará update later)
  desired_count     = 0
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_id = module.security_group.ecs_sg_id
  assign_public_ip  = false
target_group_arn = module.alb.target_group_arn
}

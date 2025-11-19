
#VPC
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

#ECR
variable "ecr_repositories" {
  type = map(string)
  description = "Repositorios ECR por microservicio"
  default = {
    apigateway = "apigateway-ecr"
    product    = "product-ecr"
    inventory  = "inventory-ecr"
  }
}

variable "apigateway_port" {
  type = number
  description = "Puerto que expone el API Gateway"
}

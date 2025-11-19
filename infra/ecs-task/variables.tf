variable "environment" { type = string }

variable "cpu" { type = number }
variable "memory" { type = number }

variable "execution_role_arn" { type = string }

variable "ecr_urls" {
  type = map(string)
}

variable "postgres_image" { type = string }
variable "redis_image" { type = string }

variable "apigateway_port" { type = number }
variable "product_port" { type = number }
variable "inventory_port" { type = number }
variable "postgres_port" { type = number }
variable "redis_port" { type = number }


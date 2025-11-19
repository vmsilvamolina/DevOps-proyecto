#Rol del laboratorio
data "aws_iam_role" "lab-rol" {
 name = "LabRole"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.environment}-core-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([
    {
      name      = "api-gateway"
      image     = "${var.ecr_urls["apigateway"]}:latest"
      essential = true

      portMappings = [
        {
          containerPort = var.apigateway_port
        }
      ]
    },
    {
      name      = "product"
      image     = "${var.ecr_urls["product"]}:latest"
      essential = true

      portMappings = [
        {
          containerPort = var.product_port
        }
      ]
    },
    {
      name      = "inventory"
      image     = "${var.ecr_urls["inventory"]}:latest"
      essential = true

      portMappings = [
        {
          containerPort = var.inventory_port
        }
      ]
    },
    {
      name      = "postgres"
      image     = var.postgres_image
      essential = true

      portMappings = [
        {
          containerPort = var.postgres_port
        }
      ]
    },
    {
      name      = "redis"
      image     = var.redis_image
      essential = true

      portMappings = [
        {
          containerPort = var.redis_port
        }
      ]
    }
  ])
}



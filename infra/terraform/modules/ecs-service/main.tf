# Task Definition Inicial
{
  "family": "dev-core-task",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "1024",
  "memory": "8192",
  "executionRoleArn": "arn:aws:iam::851725322802:role/LabRole",
  "containerDefinitions": [

    {
      "name": "postgres",
      "image": "postgres:15-alpine",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5432,
          "hostPort": 5432,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {"name": "POSTGRES_USER", "value": "admin"},
        {"name": "POSTGRES_PASSWORD", "value": "admin123"},
        {"name": "POSTGRES_DB", "value": "microservices_db"}
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/dev-core-task",
          "awslogs-region": "${AWS_REGION}",
          "awslogs-stream-prefix": "postgres"
        }
      }
    },

    {
      "name": "redis",
      "image": "redis:7-alpine",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 6379,
          "hostPort": 6379,
          "protocol": "tcp"
        }
      ],
      "environment": [],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/dev-core-task",
          "awslogs-region": "${AWS_REGION}",
          "awslogs-stream-prefix": "redis"
        }
      }
    },

    {
      "name": "product",
      "image": "${ECR_PRODUCT_URL}:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8001,
          "hostPort": 8001,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {"name": "DATABASE_URL", "value": "postgresql://admin:admin123@postgres:5432/microservices_db"},
        {"name": "REDIS_URL", "value": "redis://redis:6379"}
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/dev-core-task",
          "awslogs-region": "${AWS_REGION}",
          "awslogs-stream-prefix": "product"
        }
      },
      "dependsOn": [
        {"containerName": "postgres", "condition": "START"},
        {"containerName": "redis", "condition": "START"}
      ]
    },

    {
      "name": "inventory",
      "image": "${ECR_INVENTORY_URL}:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8002,
          "hostPort": 8002,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {"name": "DATABASE_URL", "value": "postgres://admin:admin123@postgres:5432/microservices_db?sslmode=disable"},
        {"name": "REDIS_URL", "value": "redis:6379"}
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/dev-core-task",
          "awslogs-region": "${AWS_REGION}",
          "awslogs-stream-prefix": "inventory"
        }
      },
      "dependsOn": [
        {"containerName": "postgres", "condition": "START"},
        {"containerName": "redis", "condition": "START"}
      ]
    },

    {
      "name": "api-gateway",
      "image": "${ECR_API_URL}:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8000,
          "hostPort": 8000,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {"name": "PRODUCT_SERVICE_URL", "value": "http://localhost:8001"},
        {"name": "INVENTORY_SERVICE_URL", "value": "http://localhost:8002"},
        {"name": "REDIS_URL", "value": "localhost:6379"}
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/dev-core-task",
          "awslogs-region": "${AWS_REGION}",
          "awslogs-stream-prefix": "api-gateway"
        }
      },
      "dependsOn": [
        {"containerName": "postgres", "condition": "HEALTHY"},
        {"containerName": "redis", "condition": "HEALTHY"},
        {"containerName": "product", "condition": "START"},
        {"containerName": "inventory", "condition": "START"}
      ]
    }
  ]
}

# ECS Service usando el task mínimo solo en el primer apply
resource "aws_ecs_service" "this" {
  name            = "${var.environment}-ecs-service"
  cluster         = var.cluster_id
  task_definition = task_definition = aws_ecs_task_definition.dev-core-task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "api-gateway"
    container_port   = 8000
  }
}



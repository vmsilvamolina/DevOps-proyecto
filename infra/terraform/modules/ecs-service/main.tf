# Task Definition mínimo solo para inicializar el ECS
resource "aws_ecs_task_definition" "minimal" {
  family                   = "${var.environment}-ecs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "api-gateway"
    image     = "public.ecr.aws/amazonlinux/amazonlinux:latest"
    essential = true
    portMappings = [{
      containerPort = 8080
      protocol      = "tcp"
    }]
  }])
}

# ECS Service único usando ese task mínimo
resource "aws_ecs_service" "this" {
  name            = "${var.environment}-ecs-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.minimal.arn
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
    container_port   = 8080
  }
}



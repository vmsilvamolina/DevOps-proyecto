output "service_names" {
  value = aws_ecs_service.this.name
}

output "service_arns" {
  value = aws_ecs_service.this.arn
}

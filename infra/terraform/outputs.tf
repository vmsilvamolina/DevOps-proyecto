#VPC
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

#ECR
output "ecr_urls" {
  value = module.ecr.ecr_urls
}

output "cluster_id" {
  value = module.ecs_cluster.cluster_id
}

output "alb_dns" {
  description = "DNS del Application Load Balancer"
  value       = module.alb.alb_dns
}

output "ecs_service_names" {
  description = "Nombre del ECS Service creado"
  value       = module.ecs_service_core.service_names
}

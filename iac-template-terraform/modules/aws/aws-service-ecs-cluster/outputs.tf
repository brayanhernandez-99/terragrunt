# Cluster ID
output "ecs_cluster_id" {
  description = "ID del clúster ECS creado"
  value       = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_cluster_name" {
  description = "Nombre del clúster ECS creado"
  value       = aws_ecs_cluster.ecs_cluster.name
}
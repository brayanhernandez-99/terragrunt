output "db_subnet_group_name" {
  value       = aws_db_subnet_group.subnet_group.name
  description = "Nombre del grupo de subredes de la base de datos"
}

output "cluster_id" {
  description = "Identificador del cluster de la base de datos"
  value       = aws_rds_cluster.rds.id
}

output "cluster_resource_id" {
  description = "Identificador único del recurso del cluster de la base de datos"
  value       = aws_rds_cluster.rds.cluster_resource_id
}

output "cluster_arn" {
  description = "ARN del cluster de la base de datos"
  value       = aws_rds_cluster.rds.arn
}

output "cluster_instances" {
  description = "Lista de las instancias que pertenecen al cluster de la base de datos"
  value       = aws_rds_cluster.rds.cluster_members
}

output "username" {
  description = "Usuario de la base de datos desplegada"
  value       = aws_rds_cluster.rds.master_username
}

output "password" {
  description = "Contraseña de la base de datos desplegada"
  value       = random_password.master_password.result
  sensitive   = true
}

output "reader_endpoint" {
  description = "Endpoint de lectura de la base de datos"
  value       = aws_rds_cluster.rds.reader_endpoint
}

output "endpoint" {
  description = "Endpoint principal de la base de datos"
  value       = aws_rds_cluster.rds.endpoint
}

output "port" {
  description = "Puerto de la base de datos desplegada"
  value       = aws_rds_cluster.rds.port
}

output "cluster_identifier" {
  description = "Identificador del cluster de la base de datos"
  value       = aws_rds_cluster.rds.cluster_identifier
}

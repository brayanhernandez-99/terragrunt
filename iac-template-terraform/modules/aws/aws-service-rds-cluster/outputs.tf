output "db_subnet_group_name" {
  value       = aws_db_subnet_group.subnet_group.name
  description = "Nombre del grupo de subnets de la base de datos"
}

output "cluster_id" {
  description = "The id of the aurora instance"
  value       = aws_rds_cluster.rds.id
}

output "cluster_resource_id" {
  description = "The full unique identifier of the aurora instance"
  value       = aws_rds_cluster.rds.cluster_resource_id
}

output "cluster_reader_endpoint" {
  description = "The endpoint of aurora instance"
  value       = aws_rds_cluster.rds.reader_endpoint
}

output "cluster_arn" {
  description = "The RDS Cluster Aurora cluster ARN"
  value       = aws_rds_cluster.rds.arn
}

output "cluster_instances" {
  description = "A list of all instances in the aurora cluster"
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

output "endpoint" {
  description = "Endpoint de la base de datos desplegada"
  value       = aws_rds_cluster.rds.endpoint
}

output "port" {
  description = "Puerto de la base de datos desplegada"
  value       = aws_rds_cluster.rds.port
}

output "cluster_identifier" {
  description = "Identificador del cluster de la base de datos desplegada"
  value       = aws_rds_cluster.rds.cluster_identifier
}

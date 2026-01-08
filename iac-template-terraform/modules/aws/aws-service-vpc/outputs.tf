output "vpc_id" {
  value = aws_vpc.main.id
  description = "ID de la VPC principal"
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
  description = "IDs de las subnets públicas"
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
  description = "IDs de las subnets privadas"
}

# output "cgw_id" {
#   value = aws_customer_gateway.cgw.id
#   description = "ID del grupo de seguridad para la base de datos"
# }

# output "vgw_id" {
#   value = aws_vpn_gateway.vgw.id
#   description = "ID del vgw"
# }

output "db_security_group_id" {
  value = aws_security_group.db.id
  description = "ID del grupo de seguridad para la base de datos"
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.default.name
  description = "Nombre del grupo de subnets de la base de datos"
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs_task.id
  description = "ID del grupo de seguridad para los servicios ECS"
}

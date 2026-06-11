output "cloudmap_namespace_id" {
  description = "ID del namespace de Cloud Map"
  value       = aws_service_discovery_private_dns_namespace.cloudmap.id
}

output "cloudmap_namespace_arn" {
  description = "ARN del namespace"
  value       = aws_service_discovery_private_dns_namespace.cloudmap.arn
}

output "cloudmap_namespace_name" {
  description = "Nombre DNS del namespace"
  value       = aws_service_discovery_private_dns_namespace.cloudmap.name
}

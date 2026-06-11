output "valkey_address" {
  description = "Address del Valkey Cache"
  value       = one(aws_elasticache_serverless_cache.valkey.endpoint).address
}

output "valkey_port" {
  description = "Port del Valkey Cache"
  value       = one(aws_elasticache_serverless_cache.valkey.endpoint).port
}

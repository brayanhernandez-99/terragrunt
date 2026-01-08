output "valkey_endpoint" {
  description = "Endpoint del Valkey Cache"
  value       = "${aws_elasticache_serverless_cache.valkey.endpoint[0].address}:${aws_elasticache_serverless_cache.valkey.endpoint[0].port}"
}
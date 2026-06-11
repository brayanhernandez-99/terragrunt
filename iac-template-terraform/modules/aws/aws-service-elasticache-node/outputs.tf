output "listener_port" {
  description = "Puerto del ElastiCache Valkey Streams"
  value       = aws_elasticache_replication_group.valkey_streams.port
}
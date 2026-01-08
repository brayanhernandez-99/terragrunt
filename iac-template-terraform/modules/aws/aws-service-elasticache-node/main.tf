resource "aws_elasticache_subnet_group" "valkey_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "valkey_streams" {
  replication_group_id       = var.cache_name
  description                = "Valkey streams cache"
  engine                     = "valkey"
  engine_version             = "8.1"
  node_type                  = "cache.t4g.micro"
  port                       = 6379
  parameter_group_name       = "default.valkey8"
  subnet_group_name          = aws_elasticache_subnet_group.valkey_subnet_group.name
  security_group_ids         = var.security_group_ids
  transit_encryption_enabled = true
  at_rest_encryption_enabled = true
  
  # Configuración básica single node
  num_node_groups            = 1
  replicas_per_node_group    = 0
  automatic_failover_enabled = false
  multi_az_enabled           = false
}

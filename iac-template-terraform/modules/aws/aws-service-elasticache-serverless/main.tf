resource "aws_elasticache_serverless_cache" "valkey" {
  name                 = var.cache_name
  description          = "Valkey serverless cache"
  engine               = "valkey"
  major_engine_version = "8"
  subnet_ids           = var.subnet_ids
  security_group_ids   = var.security_group_ids
}

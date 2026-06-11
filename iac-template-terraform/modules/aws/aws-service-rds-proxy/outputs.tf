output "proxy_name" {
  value = aws_db_proxy.proxy.name
}

output "proxy_endpoint" {
  value = aws_db_proxy.proxy.endpoint
}

output "proxy_arn" {
  value = aws_db_proxy.proxy.arn
}

output "proxy_target_group_name" {
  value = aws_db_proxy_default_target_group.proxy.name
}

output "proxy_read_only_endpoint" {
  value = aws_db_proxy_endpoint.read_only.endpoint
}

output "proxy_target_cluster_identifier" {
  value = aws_db_proxy_target.rds_target.db_cluster_identifier
}

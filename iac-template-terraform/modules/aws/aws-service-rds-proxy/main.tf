data "aws_secretsmanager_secret" "rds_secrets" {
  for_each = toset(var.secret_names)
  name     = each.value
}

resource "aws_db_proxy" "proxy" {
  name                   = var.name
  engine_family          = "MYSQL"
  role_arn               = var.role_arn
  vpc_subnet_ids         = var.subnet_ids
  vpc_security_group_ids = var.security_group_ids
  idle_client_timeout    = 1800
  require_tls            = false
  debug_logging          = false

  dynamic "auth" {
    for_each = data.aws_secretsmanager_secret.rds_secrets
    content {
      auth_scheme = "SECRETS"
      secret_arn  = auth.value.arn
      iam_auth    = "DISABLED"
    }
  }
}

resource "aws_db_proxy_default_target_group" "proxy" {
  db_proxy_name = aws_db_proxy.proxy.name

  connection_pool_config {
    max_connections_percent      = var.max_connections_percent
    max_idle_connections_percent = var.max_idle_connections_percent
    connection_borrow_timeout    = var.connection_borrow_timeout
  }
}

resource "aws_db_proxy_target" "rds_target" {
  db_proxy_name         = aws_db_proxy.proxy.name
  target_group_name     = aws_db_proxy_default_target_group.proxy.name
  db_cluster_identifier = var.db_cluster_identifier

  depends_on = [
    aws_db_proxy_default_target_group.proxy
  ]
}

resource "aws_db_proxy_endpoint" "read_only" {
  db_proxy_name          = aws_db_proxy.proxy.name
  db_proxy_endpoint_name = "${var.name}-read-only"
  vpc_subnet_ids         = var.subnet_ids
  vpc_security_group_ids = var.security_group_ids
  target_role            = "READ_ONLY"
}

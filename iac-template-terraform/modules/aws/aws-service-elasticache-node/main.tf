resource "aws_elasticache_subnet_group" "valkey_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "valkey_streams" {
  replication_group_id = var.cache_name
  description          = "Valkey streams cache"
  engine               = "valkey"
  engine_version       = "8.1"
  node_type            = "cache.t4g.micro"
  port                 = var.listener_port
  parameter_group_name = "default.valkey8"
  subnet_group_name    = aws_elasticache_subnet_group.valkey_subnet_group.name
  security_group_ids   = var.security_group_ids

  transit_encryption_enabled = true
  at_rest_encryption_enabled = true

  # Configuración básica single node
  num_node_groups            = 1
  replicas_per_node_group    = 0
  automatic_failover_enabled = false
  multi_az_enabled           = false
}

resource "aws_lb_target_group" "nlb_target_group" {
  name        = "${var.target_group_config.name}-nbl-tg"
  port        = var.target_group_config.port
  protocol    = "TCP"
  vpc_id      = var.target_group_config.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "TCP"
    port                = var.target_group_config.health_check_port
    interval            = var.target_group_config.health_check_interval
    timeout             = var.target_group_config.health_check_timeout
    healthy_threshold   = var.target_group_config.healthy_threshold
    unhealthy_threshold = var.target_group_config.unhealthy_threshold
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = var.nlb_arn
  port              = var.listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group.arn
  }
}

# resource "aws_lb_target_group_attachment" "nlb_target_group_attachment" {
#   target_group_arn = aws_lb_target_group.nlb_target_group.arn
#   target_id        = "0.0.0.0"
#   port             = var.listener_port
# }

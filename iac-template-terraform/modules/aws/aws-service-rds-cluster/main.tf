resource "aws_iam_role" "rds_invictus_monitoring_role" {
  name = "rds-invictus-monitoring-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_invictus_monitoring_role_attach" {
  role       = aws_iam_role.rds_invictus_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = var.cluster_config.subnet_group
  subnet_ids = var.cluster_config.private_subnet_ids
}

resource "aws_rds_cluster_parameter_group" "custom_cluster_pg" {
  name   = var.cluster_config.parameter_group
  family = "aurora-mysql8.0"

  parameter {
    name  = "interactive_timeout"
    value = "1200"
  }

  parameter {
    name  = "wait_timeout"
    value = "1200"
  }
}

resource "aws_rds_cluster" "rds" {
  apply_immediately = true

  engine                 = var.cluster_config.engine
  engine_version         = var.cluster_config.engine_version != null ? var.cluster_config.engine_version : null
  database_name          = var.cluster_config.database_name
  cluster_identifier     = var.cluster_config.cluster_identifier
  availability_zones     = var.cluster_config.avaliability_zones
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  master_username        = var.cluster_config.master_credentials.username
  master_password        = random_password.master_password.result
  vpc_security_group_ids = var.cluster_config.security_groups

  backup_retention_period = var.cluster_config.backup_retention_period != null ? var.cluster_config.backup_retention_period : null
  preferred_backup_window = var.cluster_config.preferred_backup_window != null ? var.cluster_config.preferred_backup_window : null

  storage_type              = var.cluster_config.multi_az_config.storage_type != null ? var.cluster_config.multi_az_config.storage_type : null
  allocated_storage         = var.cluster_config.multi_az_config.allocated_storage != null ? var.cluster_config.multi_az_config.allocated_storage : null
  iops                      = var.cluster_config.multi_az_config.iops != null ? var.cluster_config.multi_az_config.iops : null
  db_cluster_instance_class = var.cluster_config.multi_az_config.db_cluster_instance_class != null ? var.cluster_config.multi_az_config.db_cluster_instance_class : null
  skip_final_snapshot       = true
  deletion_protection       = true

  db_cluster_parameter_group_name       = aws_rds_cluster_parameter_group.custom_cluster_pg.name
  performance_insights_enabled          = true
  database_insights_mode                = "standard"
  performance_insights_retention_period = 7
  monitoring_role_arn                   = aws_iam_role.rds_invictus_monitoring_role.arn
  monitoring_interval                   = 60
  enabled_cloudwatch_logs_exports = [
    "audit",
    "error",
    "general",
    "instance",
    "slowquery",
    "iam-db-auth-error"
  ]

  serverlessv2_scaling_configuration {
    max_capacity = var.cluster_config.serverless_v2_config.max_capacity
    min_capacity = var.cluster_config.serverless_v2_config.min_capacity
  }
}

resource "aws_rds_cluster_instance" "rds_cluster_instances" {
  for_each          = { for idx, instance in var.instances_config : idx => instance }
  apply_immediately = true

  cluster_identifier          = aws_rds_cluster.rds.id
  identifier                  = each.value.instance_identifier
  instance_class              = each.value.instance_class != null ? each.value.instance_class : null
  db_subnet_group_name        = aws_db_subnet_group.subnet_group.name
  custom_iam_instance_profile = each.value.custom_iam_instance_profile != null ? each.value.custom_iam_instance_profile : null
  availability_zone           = each.value.availability_zone != null ? each.value.availability_zone : null

  engine              = aws_rds_cluster.rds.engine
  engine_version      = aws_rds_cluster.rds.engine_version
  monitoring_role_arn = aws_iam_role.rds_invictus_monitoring_role.arn
  monitoring_interval = 60
}

resource "random_password" "master_password" {
  length  = 24
  special = false
  numeric = true
  upper   = true
  lower   = true
}

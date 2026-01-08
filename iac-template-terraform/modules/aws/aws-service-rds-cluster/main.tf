# Description: This file contains the terraform configuration to create an RDS cluster
resource "aws_rds_cluster" "default" {
  engine                  = var.cluster_config.engine
  engine_version          = var.cluster_config.engine_version != null ? var.cluster_config.engine_version : null
  database_name           = var.cluster_config.database_name
  cluster_identifier      = var.cluster_config.cluster_identifier
  availability_zones      = var.cluster_config.avaliability_zones
  db_subnet_group_name    = var.cluster_config.subnet_group
  master_username         = var.cluster_config.master_credentials.username
  master_password         = random_password.master_password.result
  vpc_security_group_ids  = var.cluster_config.security_groups

  backup_retention_period   = var.cluster_config.backup_retention_period != null ? var.cluster_config.backup_retention_period : null
  preferred_backup_window   = var.cluster_config.preferred_backup_window != null ? var.cluster_config.preferred_backup_window : null

  storage_type              = var.cluster_config.multi_az_config.storage_type != null ? var.cluster_config.multi_az_config.storage_type : null
  allocated_storage         = var.cluster_config.multi_az_config.allocated_storage != null ? var.cluster_config.multi_az_config.allocated_storage : null
  iops                      = var.cluster_config.multi_az_config.iops != null ? var.cluster_config.multi_az_config.iops : null
  db_cluster_instance_class = var.cluster_config.multi_az_config.db_cluster_instance_class != null ? var.cluster_config.multi_az_config.db_cluster_instance_class : null
  skip_final_snapshot       = true
  deletion_protection       = true

  serverlessv2_scaling_configuration {
    max_capacity = var.cluster_config.serverless_v2_config.max_capacity
    min_capacity = var.cluster_config.serverless_v2_config.min_capacity
  }
}

resource "aws_rds_cluster_instance" "rds_cluster_instances" {
  for_each                      = {for idx, instance in var.instances_config : idx => instance }
  cluster_identifier            = aws_rds_cluster.default.id
  identifier                    = each.value.instance_identifier
  instance_class                = each.value.instance_class != null ? each.value.instance_class : null
  db_subnet_group_name          = var.cluster_config.subnet_group
  custom_iam_instance_profile   = each.value.custom_iam_instance_profile != null ? each.value.custom_iam_instance_profile : null
  availability_zone             = each.value.availability_zone != null ? each.value.availability_zone : null
  
  engine          = aws_rds_cluster.default.engine
  engine_version  = aws_rds_cluster.default.engine_version
}

resource "random_password" "master_password" {
  length  = 16
  special = false
  numeric = true
  upper   = true
  lower   = true
}

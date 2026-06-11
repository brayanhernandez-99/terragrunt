include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-rds-cluster"
}

dependency "vpc" {
  config_path = "../../aws-service-vpc"
  mock_outputs = {
    private_subnet_ids = ["mock_private_subnet_ids"]
  }
}

dependency "sg" {
  config_path = "../aws-service-sg"
  mock_outputs = {
    security_group_id = "mock_security_group_id"
  }
}

inputs = {
  cluster_config = {
    engine             = "aurora-mysql"
    engine_version     = "#{aws_rds_engine_version}#"
    cluster_identifier = "#{aws_rds_cluster_identifier}#"
    database_name      = "#{aws_rds_database_name}#"
    subnet_group       = "#{aws_rds_subnet_group}#"
    parameter_group    = "invictus-cluster-parameter-group"
    private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
    security_groups    = [dependency.sg.outputs.security_group_id]
    master_credentials = {
      username = "#{aws_rds_master_credentials_username}#"
    }
    backup_retention_period = null
    preferred_backup_window = null
    multi_az_config = {
      db_cluster_instance_class = null
      storage_type              = null
      allocated_storage         = null
      iops                      = null
    }
    serverless_v2_config = {
      min_capacity = "#{aws_rds_serverless_v2_config_min_capacity}#"
      max_capacity = "#{aws_rds_serverless_v2_config_max_capacity}#"
    }
    avaliability_zones     = ["#{aws_region}#a", "#{aws_region}#b", "#{aws_region}#c"]
    storage_encrypted      = true
    vpc_security_group_ids = [dependency.sg.outputs.security_group_id]
  }
  instances_config = [
    {
      instance_identifier         = "invictus-instance-db"
      instance_class              = "db.serverless"
      publicly_accessbile         = false
      custom_iam_instance_profile = null
      availability_zone           = null
      apply_inmediatly            = false
    },
    {
      instance_identifier         = "invictus-instance-db-reader"
      instance_class              = "db.serverless"
      publicly_accessbile         = false
      custom_iam_instance_profile = null
      availability_zone           = "#{aws_region}#b"
      apply_inmediatly            = false
    }
  ]
}

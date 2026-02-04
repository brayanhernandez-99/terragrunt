include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-rds-cluster"
}

dependency "vpc" {
  config_path = "../aws-service-vpc"
  mock_outputs = {
    db_subnet_group_name = "mock_db_subnet_group_name"
    db_security_group_id = "mock_db_security_group_id"
  }
}

inputs = {
  cluster_config = {
    engine             = "aurora-mysql"
    engine_version     = "#{aws_rds_engine_version}#"
    cluster_identifier = "#{aws_rds_cluster_identifier}#"
    database_name      = "#{aws_rds_database_name}#"
    subnet_group       = dependency.vpc.outputs.db_subnet_group_name
    security_groups    = [dependency.vpc.outputs.db_security_group_id]
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
    avaliability_zones     = ["us-east-1a", "us-east-1b", "us-east-1c"]
    storage_encrypted      = true
    vpc_security_group_ids = [dependency.vpc.outputs.db_security_group_id]
  }
  instances_config = [
    {
      instance_identifier         = "#{aws_rds_instance_identifier1}#"
      instance_class              = "db.serverless"
      publicly_accessbile         = false
      custom_iam_instance_profile = null
      availability_zone           = null
      apply_inmediatly            = false

    },
    {
      instance_identifier         = "#{aws_rds_instance_identifier2}#"
      instance_class              = "db.serverless"
      publicly_accessbile         = false
      custom_iam_instance_profile = null
      availability_zone           = "us-east-1b"
      apply_inmediatly            = false
    }
  ]
}

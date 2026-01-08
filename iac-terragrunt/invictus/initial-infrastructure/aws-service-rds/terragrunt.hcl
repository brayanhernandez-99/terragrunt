include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-rds-cluster"
}

dependency "vpc" {
  config_path                       = "../aws-service-vpc"
  mock_outputs                      = {
    db_subnet_group_name            = "mock_db_subnet_group_name"
    db_security_group_id            = "mock_db_security_group_id"
  }
}

inputs = {
  cluster_config                    = {
    engine                          = "aurora-mysql"
    engine_version                  = "8.0.mysql_aurora.3.10.0"
    cluster_identifier              = "invictus-db"
    database_name                   = "invictus_cluster_db"
    subnet_group                    = dependency.vpc.outputs.db_subnet_group_name
    security_groups                 = [dependency.vpc.outputs.db_security_group_id]
    master_credentials              = {
      username                      = "invictus"
    }
    backup_retention_period         = null
    preferred_backup_window         = null
    multi_az_config                 = {
      db_cluster_instance_class     = null
      storage_type                  = null
      allocated_storage             = null
      iops                          = null
    }
    serverless_v2_config            = {
      min_capacity                  = 0.5
      max_capacity                  = 1.5
    }
    avaliability_zones              = ["us-east-1a", "us-east-1b", "us-east-1c"]
    storage_encrypted               = true
    vpc_security_group_ids          = [dependency.vpc.outputs.db_security_group_id]
  }
  instances_config                  = [
    {
      instance_identifier           = "invictus-instance-db"
      instance_class                = "db.serverless"
      publicly_accessbile           = false
      custom_iam_instance_profile   = null
      availability_zone             = null
      apply_inmediatly              = false
      
    },
    {
      instance_identifier           = "invictus-instance-db-reader"
      instance_class                = "db.serverless"
      publicly_accessbile           = false
      custom_iam_instance_profile   = null
      availability_zone             = "us-east-1b"
      apply_inmediatly              = false
    }
  ]
}

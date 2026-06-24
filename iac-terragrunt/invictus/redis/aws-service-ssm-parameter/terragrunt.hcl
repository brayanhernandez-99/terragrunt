include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = basename(dirname(get_terragrunt_dir()))
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "elasticache" {
  config_path = "../aws-service-elasticache"
  mock_outputs = {
    valkey_address = "cluster.serverless.use1.cache.amazonaws.com"
    valkey_port    = "6379"
  }
}

inputs = {
  ssm_parameters = {
    REDIS_BASE_URL = {
      type        = "String"
      name        = "/GLOBAL/REDIS_BASE_URL"
      value       = "rediss://${dependency.elasticache.outputs.valkey_address}:${dependency.elasticache.outputs.valkey_port}"
      description = "URL para el redis cache de invictus"
    }
  }
}
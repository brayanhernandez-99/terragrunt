locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "elasticache" {           
  config_path           = "../aws-service-elasticache-serverless"
  mock_outputs          = {
    valkey_endpoint     = "mock-valkey-endpoint"
  }
}

inputs                  = {
  ssm_parameters        = {
    PRODUCER_BASE_URL   = {
      type              = "String"
      name              = "/GLOBAL/REDIS_BASE_URL"
      value             = "rediss://${dependency.elasticache.outputs.valkey_endpoint}"
      description       = "URL para el redis cache de invictus"
    }
  }
}
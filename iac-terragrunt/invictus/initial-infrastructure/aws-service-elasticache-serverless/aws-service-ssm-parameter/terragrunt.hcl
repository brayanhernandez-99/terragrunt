include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "elasticache" {
  config_path = "../aws-service-elasticache"
  mock_outputs = {
    valkey_address = "mock-valkey-address"
    valkey_port    = "mock-valkey-port"
  }
}

inputs = {
  ssm_parameters = {
    STREAM_BASE_URL = {
      type        = "String"
      name        = "/GLOBAL/STREAM_BASE_URL"
      value       = "rediss://${dependency.elasticache.outputs.valkey_address}:${dependency.elasticache.outputs.valkey_port}"
      description = "URL para el redis cache de invictus"
    }
  }
}
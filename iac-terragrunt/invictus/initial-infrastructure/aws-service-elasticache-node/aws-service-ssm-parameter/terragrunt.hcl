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
    listener_port = "mock-listener-port"
  }
}

dependency "load_balancer" {
  config_path = "../aws-service-load-balancer"
  mock_outputs = {
    nlb_dns_name = "mock-nlb-dns-name"
  }
}

inputs = {
  ssm_parameters = {
    STREAM_BASE_URL = {
      type        = "String"
      name        = "/GLOBAL/STREAM_BASE_URL"
      value       = "redis://${dependency.load_balancer.outputs.nlb_dns_name}:${dependency.elasticache.outputs.listener_port}/"
      description = "URL para el cache de invictus"
    }
  }
}
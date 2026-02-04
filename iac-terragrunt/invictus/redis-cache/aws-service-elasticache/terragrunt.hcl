include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-elasticache-serverless"
}

dependency "vpc" {
  config_path = "../../initial-infrastructure/aws-service-vpc"
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
  cache_name         = "invictus-cache"
  subnet_ids         = dependency.vpc.outputs.private_subnet_ids
  security_group_ids = [dependency.sg.outputs.security_group_id]
}
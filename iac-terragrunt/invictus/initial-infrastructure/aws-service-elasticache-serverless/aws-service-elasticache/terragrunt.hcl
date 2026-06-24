include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = basename(dirname(get_terragrunt_dir()))
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-elasticache-serverless"
}

dependency "vpc" {
  config_path = "../../aws-service-vpc"
  mock_outputs = {
    private_subnet_ids = ["subnet-0a1b2c3d4e5f67890", "subnet-0a1b2c3d4e5f67891"]
  }
}

dependency "sg" {
  config_path = "../aws-service-sg"
  mock_outputs = {
    security_group_id = "sg-0a1b2c3d4e5f67890"
  }
}

inputs = {
  cache_name         = "invictus-stream"
  subnet_ids         = dependency.vpc.outputs.private_subnet_ids
  security_group_ids = [dependency.sg.outputs.security_group_id]
}
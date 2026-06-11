include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-load-balancer"
}

dependency "vpc" {
  config_path = "../aws-service-vpc"
  mock_outputs = {
    private_subnet_ids = ["mock_private_subnet_ids"]
  }
}

inputs = {
  nlb_name     = "invictus-nlb"
  nlb_internal = true
  subnet_ids   = dependency.vpc.outputs.private_subnet_ids
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-load-balancer"
}

dependency "vpc" {
  config_path = "../../aws-service-vpc"
  mock_outputs = {
    public_subnet_ids = ["mock_public_subnet_ids"]
  }
}

inputs = {
  nlb_name     = "stream-nlb"
  nlb_internal = false
  subnet_ids   = dependency.vpc.outputs.public_subnet_ids
}

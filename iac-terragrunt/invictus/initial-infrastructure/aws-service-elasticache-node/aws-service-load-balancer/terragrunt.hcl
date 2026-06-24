include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-load-balancer"
}

dependency "vpc" {
  config_path = "../../aws-service-vpc"
  mock_outputs = {
    public_subnet_ids = ["subnet-0a1b2c3d4e5f67892", "subnet-0a1b2c3d4e5f67893"]
  }
}

inputs = {
  nlb_name     = "stream-nlb"
  nlb_internal = false
  subnet_ids   = dependency.vpc.outputs.public_subnet_ids
}

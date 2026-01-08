include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-vpc-endpoints-interface"
}

dependency "vpc"       {
  config_path          = "../../../initial-infrastructure/aws-service-vpc"
  mock_outputs         = {
    vpc_id             = "mock_vpc_id"
    private_subnet_ids = ["mock_private_subnet_ids"]
  }
}

dependency "sg"    {
  config_path          = "../../../initial-infrastructure/aws-service-vpc-endpoints/aws-sg"
  mock_outputs         = {
    security_group_id  = "mock_security_group_id"
  }
}

inputs = {
  vpc_id               = dependency.vpc.outputs.vpc_id
  service_name         = "com.amazonaws.us-east-1.ssm"
  subnet_ids           = dependency.vpc.outputs.private_subnet_ids
  sg_id                = dependency.sg.outputs.security_group_id
  name_endpoint        = "ssm-invictus"
}
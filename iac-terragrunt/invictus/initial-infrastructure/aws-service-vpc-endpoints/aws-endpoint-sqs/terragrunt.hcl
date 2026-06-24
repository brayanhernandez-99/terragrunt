include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-vpc-endpoints-interface"
}

dependency "vpc" {
  config_path = "../../aws-service-vpc"
  mock_outputs = {
    vpc_id             = "vpc-0a1b2c3d4e5f67890"
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
  vpc_id        = dependency.vpc.outputs.vpc_id
  service_name  = "com.amazonaws.#{aws_region}#.sqs"
  subnet_ids    = dependency.vpc.outputs.private_subnet_ids
  sg_id         = dependency.sg.outputs.security_group_id
  name_endpoint = "sqs-invictus"
}
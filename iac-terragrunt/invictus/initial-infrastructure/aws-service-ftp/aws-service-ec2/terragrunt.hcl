include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ec2"
}

dependency "vpc" {
  config_path             = "../../../initial-infrastructure/aws-service-vpc"
  mock_outputs            = {
    private_subnet_ids    = ["mock_private_subnet_ids"]
  }
}

dependency "sg" {
  config_path             = "../../../initial-infrastructure/aws-service-ftp/aws-service-sg"
  mock_outputs            = {
    security_group_id     = "mock_security_group_id"
  }
}

dependency "iam" {
  config_path             = "../../../initial-infrastructure/aws-service-ftp/aws-service-iam"
  mock_outputs            = {
    instance_profile_name = "mock_instance_profile_name"
  }
}

inputs = {
  ami                     = "ami-08c40ec9ead489470"
  instance_name           = "ftp-collections-invictus"
  instance_type           = "t3.medium"
  sg_id                   = dependency.sg.outputs.security_group_id
  subnet_id               = dependency.vpc.outputs.private_subnet_ids[0]
  instance_profile_name   = dependency.iam.outputs.instance_profile_name
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-sg"
}

dependency "vpc" {
  config_path = "../../aws-service-vpc"
  mock_outputs = {
    vpc_id = "mock_vpc_id"
  }
}

inputs = {
  name_sg     = "endpoints-invictus-sg"
  description = "Security group for endpoints"
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress = [
    {
      description = "Ingress endpoints"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["#{aws_vpc_cidr_block}#"]
    }
  ]

  egress = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

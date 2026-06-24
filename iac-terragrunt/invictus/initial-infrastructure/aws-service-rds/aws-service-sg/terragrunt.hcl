include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-sg"
}

dependency "vpc" {
  config_path = "../../aws-service-vpc"
  mock_outputs = {
    vpc_id = "vpc-0a1b2c3d4e5f67890"
  }
}

inputs = {
  name_sg     = "rds-invictus-sg"
  vpc_id      = dependency.vpc.outputs.vpc_id
  description = "Allow egress and ingress traffic for RDS"

  ingress = [
    {
      description = "MySQL/Aurora ingress traffic"
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["#{aws_vpc_cidr_block}#"]
    },
    {
      description = "Zabbix Proxy AWS"
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["10.150.0.226/32"]
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

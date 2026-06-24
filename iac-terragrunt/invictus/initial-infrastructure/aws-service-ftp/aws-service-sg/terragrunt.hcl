include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-sg"
}

dependency "vpc" {
  config_path = "../../../initial-infrastructure/aws-service-vpc"
  mock_outputs = {
    vpc_id = "vpc-0a1b2c3d4e5f67890"
  }
}

inputs = {
  name_sg     = "ftp-invictus-sg"
  vpc_id      = dependency.vpc.outputs.vpc_id
  description = "Security group for FTP service"

  ingress = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["#{aws_vpc_cidr_block}#"]
    },
    {
      description = "VSFTPD"
      from_port   = "#{aws_ftp_listen_port}#"
      to_port     = "#{aws_ftp_listen_port}#"
      protocol    = "tcp"
      cidr_blocks = ["#{aws_vpc_cidr_block}#"]
    },
    {
      description = "VSFTPD PASV"
      from_port   = "#{aws_ftp_pasv_min}#"
      to_port     = "#{aws_ftp_pasv_max}#"
      protocol    = "tcp"
      cidr_blocks = ["#{aws_vpc_cidr_block}#"]
    },
    {
      description = "FTG"
      from_port   = "#{aws_ftp_listen_port}#"
      to_port     = "#{aws_ftp_listen_port}#"
      protocol    = "tcp"
      cidr_blocks = ["#{aws_ftp_source_fortigate}#"]
    },
    {
      description = "FTG"
      from_port   = "#{aws_ftp_pasv_min}#"
      to_port     = "#{aws_ftp_pasv_max}#"
      protocol    = "tcp"
      cidr_blocks = ["#{aws_ftp_source_fortigate}#"]
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

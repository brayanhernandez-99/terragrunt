generate "provider" {
  path          = "provider.tf"
  if_exists     = "overwrite_terragrunt"
  contents      = <<EOF
  terraform {
    required_providers {
      aws       = {
        source  = "hashicorp/aws"
        version = "= 6.8.0"
      }
    }
  }
  provider "aws" {
    region          = "#{aws_region}#"
    default_tags {
      tags          = {
        Owner       = "#{aws_owner}#"
        Environment = "#{aws_environment}#"
        cliente     = "#{aws_cliente}#"
        proyecto    = "invictus"
      }
    }
  }
EOF
}

generate "backend" {
  path          = "backend.tf"
  if_exists     = "overwrite_terragrunt"
  contents      = <<EOF
  terraform {
    backend "s3" {
      bucket    = "#{aws_bucket}#"
      key       = "${path_relative_to_include()}/terraform.tfstate"
      region    = "#{aws_region}#"
    }
  }
EOF
}

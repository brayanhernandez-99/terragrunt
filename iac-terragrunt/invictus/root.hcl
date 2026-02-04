generate "provider" {
  path          = "provider.tf"
  if_exists     = "overwrite_terragrunt"
  contents      = <<EOF
  terraform {
    required_providers {
      aws       = {
        source  = "hashicorp/aws"
        version = "~> 6.8.0"
      }
    }
  }
  provider "aws" {
    region          = "us-east-1"
    default_tags {
      tags          = {
        Owner       = "#{aws_owner}#"
        Environment = "#{aws_environment}#"
      }
    }
  }
EOF
}

# Backend Bucket
generate "backend" {
  path          = "backend.tf"
  if_exists     = "overwrite_terragrunt"
  contents      = <<EOF
  terraform {
    backend "s3" {
      bucket    = "#{aws_bucket}#"
      key       = "${path_relative_to_include()}/terraform.tfstate"
      region    = "us-east-1"
    }
  }
EOF
}

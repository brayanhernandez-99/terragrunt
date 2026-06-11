terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.8.0"
    }
  }
}

provider "aws" {
  region = "#{aws_region}#"
  default_tags {
    tags = {
      Owner       = "#{aws_owner}#"
      Environment = "#{aws_environment}#"
      cliente     = "#{aws_cliente}#"
      proyecto    = "invictus"
    }
  }
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-elasticache-node"
}

dependency "vpc" {
  config_path = "../../aws-service-vpc"
  mock_outputs = {
    public_subnet_ids = ["mock_public_subnet_ids"]
  }
}

dependency "sg" {
  config_path = "../aws-service-sg"
  mock_outputs = {
    security_group_id = "mock_security_group_id"
  }
}

dependency "load_balancer" {
  config_path = "../aws-service-load-balancer"
  mock_outputs = {
    nlb_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/mock-nlb-arn"
  }
}

inputs = {
  cache_name         = "invictus-stream"
  subnet_group_name  = "invictus-public-subnet-group"
  subnet_ids         = dependency.vpc.outputs.public_subnet_ids
  security_group_ids = [dependency.sg.outputs.security_group_id]

  target_group_config = {
    name                  = "stream"
    port                  = 6379
    vpc_id                = dependency.vpc.outputs.vpc_id
    health_check_port     = 6379
    health_check_interval = 30
    health_check_timeout  = 20
    healthy_threshold     = 5
    unhealthy_threshold   = 2
  }

  listener_port = 6379
  nlb_arn       = dependency.load_balancer.outputs.nlb_arn
}

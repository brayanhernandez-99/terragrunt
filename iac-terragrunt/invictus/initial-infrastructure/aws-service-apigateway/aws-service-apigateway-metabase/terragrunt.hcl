include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-apigateway"
}

dependency "iam_role" {
  config_path = "../aws-service-apigateway-iam-rol"
  mock_outputs = {
    role_arn = "arn:aws:iam::123456789012:role/role"
  }
}

dependency "load_balancer" {
  config_path = "../../aws-service-load-balancer"
  mock_outputs = {
    nlb_dns_name = "nlb-123456.elb.us-east-1.amazonaws.com"
  }
}

dependency "vpc_link" {
  config_path = "../../aws-service-vpc-link"
  mock_outputs = {
    vpc_link_id = "vpclink-0a1b2c3d4e5f67890"
  }
}

inputs = {
  api_name          = "#{aws_api_name_metabase}#"
  stage_name        = "prod"
  api_endpoint_type = "REGIONAL"
  nlb_listener      = "3000"
  nlb_dns_name      = dependency.load_balancer.outputs.nlb_dns_name
  vpc_link          = dependency.vpc_link.outputs.vpc_link_id
  role_arn          = dependency.iam_role.outputs.role_arn
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-apigateway"
}

dependency "iam_role" {
  config_path = "../aws-service-apigateway-iam-rol"
  mock_outputs = {
    role_arn = "arn:aws:iam::123456789012:role/mock-iam-role-arn"
  }
}

dependency "load_balancer" {
  config_path = "../../aws-service-load-balancer"
  mock_outputs = {
    nlb_dns_name = "mock_nlb_dns_name"
  }
}

dependency "vpc_link" {
  config_path = "../../aws-service-vpc-link"
  mock_outputs = {
    vpc_link_id = "mock_vpc_link_id"
  }
}

inputs = {
  api_name          = "#{aws_api_name_mock}#"
  stage_name        = "prod"
  api_endpoint_type = "REGIONAL"
  nlb_listener      = "3001"
  nlb_dns_name      = dependency.load_balancer.outputs.nlb_dns_name
  vpc_link          = dependency.vpc_link.outputs.vpc_link_id
  role_arn          = dependency.iam_role.outputs.role_arn
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-apigateway"
}

dependency "load_balancer" {
  config_path              = "../../initial-infrastructure/aws-service-load-balancer"
  mock_outputs             = {
    nlb_arn                = "mock_nlb_arn"
    nlb_dns_name           = "mock_nlb_dns_name"
  }
}

dependency "vpc_link"      {
  config_path              = "../../initial-infrastructure/aws-service-vpc-link"
  mock_outputs             = {
    vpc_link_id            = "mock_vpc_link_id"
  }
}

inputs = {
  api_name                 = "#{aws_api_name_admin}#"
  http_method              = "GET"
  path_part                = "root"
  integration_type         = "MOCK"
  authorization_type       = "NONE"
  stage_name               = "prod"
  api_endpoint_type        = "REGIONAL"
  request_template         = "<response>\n  <statusCode>200</statusCode>\n  <message>Custom XML response</message>\n</response>"
  vpc_link                 = dependency.vpc_link.outputs.vpc_link_id
  nlb_arn                  = dependency.load_balancer.outputs.nlb_arn
  nlb_dns_name             = dependency.load_balancer.outputs.nlb_dns_name
}

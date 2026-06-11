include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-vpc-link"
}

dependency "load_balancer" {
  config_path = "../aws-service-load-balancer"
  mock_outputs = {
    nlb_arn      = "mock_nlb_arn"
    nlb_dns_name = "mock_nlb_dns_name"
  }
}

inputs = {
  vpc_link     = "#{aws_vpc_link}#"
  nlb_arn      = dependency.load_balancer.outputs.nlb_arn
  nlb_dns_name = dependency.load_balancer.outputs.nlb_dns_name
}

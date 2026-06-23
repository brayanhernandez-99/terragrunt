include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-apigateway-domain-names"
}

dependency "apigateway_mock" {
  config_path = "../aws-service-apigateway-mock"
  mock_outputs = {
    api_id = "a1b2c3d4e5"
  }
}

inputs = {
  Domain_name     = "#{aws_custom_domain_mock}#"
  arn_certificate = "#{aws_arn_certificate}#"
  api_id          = dependency.apigateway_mock.outputs.api_id
  stage_name      = "prod"
}

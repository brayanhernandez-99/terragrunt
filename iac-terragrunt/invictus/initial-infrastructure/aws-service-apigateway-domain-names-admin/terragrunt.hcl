include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-apigateway-domain-names"
}

dependency "apigateway_administration" {
  config_path = "../aws-service-apigateway-administration"
  mock_outputs = {
    api_id = "mock_api_id"
  }
}

inputs = {
  Domain_name     = "#{aws_custom_domain_admin}#"
  arn_certificate = "#{aws_arn_certificate}#"
  api_id          = dependency.apigateway_administration.outputs.api_id
  stage_name      = "prod"
}

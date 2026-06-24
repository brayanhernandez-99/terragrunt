include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-cognito-identity-pool"
}

dependency "cognito" {
  config_path = "../aws-service-cognito"
  mock_outputs = {
    user_pool_id        = "us-east-1_poolId"
    user_pool_client_id = "1a2b3c4d5e6f7g8h9i0j1k2l3m"
  }
}

inputs = {
  region              = "#{aws_region}#"
  user_pool_id        = dependency.cognito.outputs.user_pool_id
  user_pool_client_id = dependency.cognito.outputs.user_pool_client_id
}

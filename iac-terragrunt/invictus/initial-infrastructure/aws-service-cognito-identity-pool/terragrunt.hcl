include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-cognito-identity-pool"
}

dependency "cognito" {
  config_path = "../aws-service-cognito"
  mock_outputs = {
    user_pool_id        = "mock_user_pool_id"
    user_pool_client_id = "mock_user_pool_client_id"
  }
}

inputs = {
  user_pool_id        = dependency.cognito.outputs.user_pool_id
  user_pool_client_id = dependency.cognito.outputs.user_pool_client_id
}

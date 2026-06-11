include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = basename(dirname(get_terragrunt_dir()))
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

dependency "rds" {
  config_path = "../../initial-infrastructure/aws-service-rds/aws-service-rds"
  mock_outputs = {
    username = "mock-username"
    password = "mock-password"
  }
}

dependency "random_password" {
  config_path = "../aws-service-random-password"
  mock_outputs = {
    password = "mock-password"
  }
}

inputs = {
  secret_name        = "${local.service}-relational-rds-secret"
  secret_description = "Secretos de conexión utilizados por Trino"
  secret_string_value = {
    user            = "#{secret_trino-secret_user}#"
    password        = "#{secret_trino-secret_password}#"
    clusterUser     = local.service
    clusterPassword = dependency.random_password.outputs.password
  }
}
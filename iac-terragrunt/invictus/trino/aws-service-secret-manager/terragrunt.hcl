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
    username = "user"
    password = "password"
  }
}

dependency "rds_proxy" {
  config_path = "../../initial-infrastructure/aws-service-rds/aws-service-proxy"
  mock_outputs = {
    proxy_read_only_endpoint = "proxy.proxy-123456789012.us-east-1.rds.amazonaws.com"
  }
}

inputs = {
  secret_name        = "${local.service}-relational-rds-secret"
  secret_description = "Secretos de conexión utilizados por Trino"
  secret_string_value = {
    user            = "#{secret_trino-secret_user}#"
    password        = "#{secret_trino-secret_password}#"
    clusterUser     = local.service
    clusterPassword = ""
    clusterEndpoint = dependency.rds_proxy.outputs.proxy_read_only_endpoint
    clusterPort     = dependency.rds.outputs.port
  }
}
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
    username           = "dbadmin"
    password           = "mock-password"
    endpoint           = "mock-cluster.cluster-123456789012.us-east-1.rds.amazonaws.com"
    port               = "3306"
    cluster_identifier = "mock-rds-cluster"
  }
}

dependency "rds_proxy" {
  config_path = "../../initial-infrastructure/aws-service-rds/aws-service-proxy"
  mock_outputs = {
    proxy_endpoint = "mock-proxy.proxy-123456789012.us-east-1.rds.amazonaws.com"
  }
}

inputs = {
  secret_name        = "${local.service}-relational-rds-secret"
  secret_description = "Secretos de la base de datos de ${local.service}"
  secret_string_value = {
    username            = local.service
    password            = ""
    engine              = "mysql"
    host                = dependency.rds_proxy.outputs.proxy_endpoint
    port                = dependency.rds.outputs.port
    dbClusterIdentifier = dependency.rds.outputs.cluster_identifier
    dbname              = local.service
    connectionLimit     = "#{secret_payments_connectionLimit}#"
  }
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

dependency "rds"        {
  config_path           = "../../initial-infrastructure/aws-service-rds"
  mock_outputs          = {
    username            = "mock-username"
    password            = "mock-password"
    endpoint            = "mock-endpoint"
    port                = "mock-port"
    cluster_identifier  = "mock-cluster-identifier"
  }
}

inputs                  = {
  secret_name           = "${local.service}-relational-rds-secret"
  secret_description    = "Secretos de la base de datos de ${local.service}"
  secret_string_value   = {
    username            = "${dependency.rds.outputs.username}"
    password            = "${dependency.rds.outputs.password}"
    engine              = "mysql"
    host                = "${dependency.rds.outputs.endpoint}"
    port                = "${dependency.rds.outputs.port}"
    dbClusterIdentifier = "${dependency.rds.outputs.cluster_identifier}"
    dbname              = "${local.service}"
  }
}
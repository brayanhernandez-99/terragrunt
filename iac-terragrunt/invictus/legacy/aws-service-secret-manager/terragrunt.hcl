include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs                 = {
  secret_name          = "${local.service}-relational-rds-secret"
  secret_description   = "Secretos de la base de datos de ${local.service}"
  secret_string_value  = {
    username           = "#{secret_legacy-relational-rds-secret_username}#"
    password           = "#{secret_legacy-relational-rds-secret_password}#"
    engine             = "#{secret_legacy-relational-rds-secret_engine}#"
    host               = "#{secret_legacy-relational-rds-secret_host}#"
    port               = "#{secret_legacy-relational-rds-secret_port}#"
    dbname             = "#{secret_legacy-relational-rds-secret_dbname}#"
    poolIncrement      = "#{secret_legacy-relational-rds-secret_poolIncrement}#"
    poolMax            = "#{secret_legacy-relational-rds-secret_poolMax}#"
    poolMin            = "#{secret_legacy-relational-rds-secret_poolMin}#"
    serviceName        = "#{secret_legacy-relational-rds-secret_serviceName}#"
    connectString      = "#{secret_legacy-relational-rds-secret_connectString}#"
    connectionString   = "#{secret_legacy-relational-rds-secret_connectionString}#"
  }
}

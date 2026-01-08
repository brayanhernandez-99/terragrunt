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
  secret_name          = "bemovil-secret"
  secret_description   = "Secreto de conexión a BeMovil"
  secret_string_value  = {
    baseUrl            = "#{secret_bemovil-secret_baseUrl}#"
    user               = "#{secret_bemovil-secret_user}#"
    password           = "#{secret_bemovil-secret_password}#"
  }
}
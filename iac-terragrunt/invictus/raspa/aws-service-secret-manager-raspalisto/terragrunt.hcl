include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = basename(dirname(get_terragrunt_dir()))
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs = {
  secret_name        = "raspalistosecret"
  secret_description = "Secretos de las credenciales de conexion al servicio de raspa y listo"
  secret_string_value = {
    baseUrl  = "#{secret_raspalistosecret_baseUrl}#"
    username = "#{secret_raspalistosecret_username}#"
    password = "#{secret_raspalistosecret_password}#"
  }
}
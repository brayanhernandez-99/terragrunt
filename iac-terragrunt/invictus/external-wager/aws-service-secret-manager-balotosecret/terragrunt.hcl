include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs = {
  secret_name        = "balotosecret"
  secret_description = "Secreto para almacenar la informacion de conexion para baloto"
  secret_string_value = {
    baseUrl        = "#{secret_balotosecret_baseUrl}#"
    enterprise     = "#{secret_balotosecret_enterprise}#"
    timeout        = "#{secret_balotosecret_timeout}#"
    enterpriseKey  = "#{secret_balotosecret_enterpriseKey}#"
    timeoutconsult = "#{secret_balotosecret_timeoutconsult}#"
    timeoutreverse = "#{secret_balotosecret_timeoutreverse}#"
  }
}
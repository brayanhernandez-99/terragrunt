include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs                  = {
  secret_name           = "colorlotosecret"
  secret_description    = "Secreto para almacenar la informacion de conexion para Colorloto"
  secret_string_value   = {
    baseUrl             = "#{secret_colorlotosecret_baseUrl}#"
    enterprise          = "#{secret_colorlotosecret_enterprise}#"
    timeout             = "#{secret_colorlotosecret_timeout}#"
    enterpriseKey       = "#{secret_colorlotosecret_enterpriseKey}#"
    timeoutconsult      = "#{secret_colorlotosecret_timeoutconsult}#"
    timeoutreverse      = "#{secret_colorlotosecret_timeoutreverse}#"
  }
}
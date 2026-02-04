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
  secret_name        = "coltefinancierasecret"
  secret_description = "Nombre del secreto que contiene la información de la conexión a los servicios de coltefinanciera"
  secret_string_value = {
    apiKeyName  = "#{secret_coltefinancierasecret_apiKeyName}#"
    apiKeyValue = "#{secret_coltefinancierasecret_apiKeyValue}#"
    baseUrl     = "#{secret_coltefinancierasecret_baseUrl}#"
    officeCode  = "#{secret_coltefinancierasecret_officeCode}#"
    timeout     = "#{secret_coltefinancierasecret_timeout}#"
    email       = "#{secret_coltefinancierasecret_email}#"
  }
}

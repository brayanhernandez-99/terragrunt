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
  secret_name        = "flamingosecret"
  secret_description = "Secreto de conexión a flamingosecret"
  secret_string_value = {
    wsdl       = "#{secret_flamingosecret_wsdl}#"
    urlService = "#{secret_flamingosecret_urlService}#"
    timeout    = "#{secret_flamingosecret_timeout}#"
    nitUsuario = "#{secret_flamingosecret_nitUsuario}#"
  }
}
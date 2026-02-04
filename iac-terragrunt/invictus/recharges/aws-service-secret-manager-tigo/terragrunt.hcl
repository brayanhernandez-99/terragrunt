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
  secret_name        = "recharges-tigo-secret"
  secret_description = "Secreto para el producto recharges para paquetes Tigo"
  secret_string_value = {
    usuario    = "#{secret_recharges-tigo-secret_usuario}#"
    clave      = "#{secret_recharges-tigo-secret_clave}#"
    serviceUrl = "#{secret_recharges-tigo-secret_serviceUrl}#"
    urlWsdl    = "#{secret_recharges-tigo-secret_urlWsdl}#"
    timeout    = "#{secret_recharges-tigo-secret_timeout}#"
  }
}
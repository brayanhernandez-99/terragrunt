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
  secret_name          = "conexredsecret"
  secret_description   = "Secreto de conexión a Conexred"
  secret_string_value  = {
    baseUrl            = "#{secret_conexredsecret_baseUrl}#"
    usuarioHost        = "#{secret_conexredsecret_usuarioHost}#"
    claveHost          = "#{secret_conexredsecret_claveHost}#"
    codigoComercio     = "#{secret_conexredsecret_codigoComercio}#"
    puntoVenta         = "#{secret_conexredsecret_puntoVenta}#"
    terminal           = "#{secret_conexredsecret_terminal}#"
    claveCxr           = "#{secret_conexredsecret_claveCxr}#"
    timeout            = "#{secret_conexredsecret_timeout}#"
  }
}
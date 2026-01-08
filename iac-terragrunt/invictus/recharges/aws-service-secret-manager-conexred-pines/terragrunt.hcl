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
  secret_name          = "conexred-pines-secret"
  secret_description   = "Secreto de conexión a Conexred Pines"
  secret_string_value  = {
    baseUrl            = "#{secret_conexred-pines-secret_baseUrl}#"
    usuarioHost        = "#{secret_conexred-pines-secret_usuarioHost}#"
    claveHost          = "#{secret_conexred-pines-secret_claveHost}#"
    codigoComercio     = "#{secret_conexred-pines-secret_codigoComercio}#"
    puntoVenta         = "#{secret_conexred-pines-secret_puntoVenta}#"
    terminal           = "#{secret_conexred-pines-secret_terminal}#"
    claveCxr           = "#{secret_conexred-pines-secret_claveCxr}#"
    timeout            = "#{secret_conexred-pines-secret_timeout}#"
  }
}
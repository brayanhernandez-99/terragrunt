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
  secret_name          = "conexred-cashin-secret"
  secret_description   = "Secreto para el producto de Cash-in Conexred"
  secret_string_value  = {
    baseUrl            = "#{secret_conexred-cashin-secret_baseUrl}#"
    usuarioHost        = "#{secret_conexred-cashin-secret_usuarioHost}#"
    claveHost          = "#{secret_conexred-cashin-secret_claveHost}#"
    codigoComercio     = "#{secret_conexred-cashin-secret_codigoComercio}#"
    puntoVenta         = "#{secret_conexred-cashin-secret_puntoVenta}#"
    terminal           = "#{secret_conexred-cashin-secret_terminal}#"
    claveCxr           = "#{secret_conexred-cashin-secret_claveCxr}#"
    timeout            = "#{secret_conexred-cashin-secret_timeout}#"
  }
}
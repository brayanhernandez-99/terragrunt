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
  secret_name        = "transferimossecret"
  secret_description = "Conexión del aliado Transferimos"
  secret_string_value = {
    baseUrl        = "#{secret_transferimossecret_baseUrl}#"
    usuarioHost    = "#{secret_transferimossecret_usuarioHost}#"
    claveHost      = "#{secret_transferimossecret_claveHost}#"
    codigoComercio = "#{secret_transferimossecret_codigoComercio}#"
    puntoVenta     = "#{secret_transferimossecret_puntoVenta}#"
    terminal       = "#{secret_transferimossecret_terminal}#"
    claveCxr       = "#{secret_transferimossecret_claveCxr}#"
  }
}

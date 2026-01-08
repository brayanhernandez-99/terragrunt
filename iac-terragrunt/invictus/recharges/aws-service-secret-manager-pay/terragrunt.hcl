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
  secret_name          = "conexredsecretpay"
  secret_description   = "Secreto para el producto de Cash-out Conexred"
  secret_string_value  = {
    baseUrl            = "#{secret_conexredsecretpay_baseUrl}#"
    usuarioHost        = "#{secret_conexredsecretpay_usuarioHost}#"
    claveHost          = "#{secret_conexredsecretpay_claveHost}#"
    codigoComercio     = "#{secret_conexredsecretpay_codigoComercio}#"
    puntoVenta         = "#{secret_conexredsecretpay_puntoVenta}#"
    terminal           = "#{secret_conexredsecretpay_terminal}#"
    claveCxr           = "#{secret_conexredsecretpay_claveCxr}#"
    timeout            = "#{secret_conexredsecretpay_timeout}#"
  }
}
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
  secret_name          = "conexred-recaudos-secret"
  secret_description   = "Secreto para el producto de Cash-out Conexred"
  secret_string_value  = {
    baseUrl            = "#{secret_conexred-recaudos-secret_baseurl}#"
    usuarioHost        = "#{secret_conexred-recaudos-secret_usuariohost}#"
    claveHost          = "#{secret_conexred-recaudos-secret_clavehost}#"
    codigoComercio     = "#{secret_conexred-recaudos-secret_codigocomercio}#"
    puntoVenta         = "#{secret_conexred-recaudos-secret_puntoventa}#"
    terminal           = "#{secret_conexred-recaudos-secret_terminal}#"
    claveCxr           = "#{secret_conexred-recaudos-secret_clavecxr}#"
    timeout            = "#{secret_conexred-recaudos-secret_timeout}#"
  }
}
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
  secret_name          = "flamingotarjetasecret"
  secret_description   = "Secreto de conexión a flamingotarjetasecret"
  secret_string_value  = {
    wsdl               = "#{secret_flamingotarjetasecret_wsdl}#"
    urlService         = "#{secret_flamingotarjetasecret_urlService}#"
    timeout            = "#{secret_flamingotarjetasecret_utimeout}#"
    codigoAlmacen      = "#{secret_flamingotarjetasecret_codigoAlmacen}#"
  }
}
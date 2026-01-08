include "root" {
  path                  = find_in_parent_folders("root.hcl")
}

locals {
  service               = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source                = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs                    = {
  secret_name             = "billing-general-customer-config"
  secret_description      = "Vendedor generico para factura electronica"
  secret_string_value     = {
    name                  = "#{secret_billing-general-customer-config_name}#"
    organizationType      = "#{secret_billing-general-customer-config_organizationType}#"
    identificationType    = "#{secret_billing-general-customer-config_identificationType}#"
    identificationNumber  = "#{secret_billing-general-customer-config_identificationNumber}#"
    regimeCode            = "#{secret_billing-general-customer-config_regimeCode}#"
    taxCode               = "#{secret_billing-general-customer-config_taxCode}#"       # Escapar values .json: {\"...\"}
  }
}
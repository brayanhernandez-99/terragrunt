include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs                    = {
  secret_name             = "billing-company-config"
  secret_description      = "Información de la empresa enviada a alegra"
  secret_string_value     = {
    id                    = "#{secret_billing-company-config_id}#"
    identificationType    = "#{secret_billing-company-config_identificationType}#"
    organizationType      = "#{secret_billing-company-config_organizationType}#"
    identificationNumber  = "#{secret_billing-company-config_identificationNumber}#"
    dv                    = "#{secret_billing-company-config_dv}#"
    name                  = "#{secret_billing-company-config_name}#"
    tradeName             = "#{secret_billing-company-config_tradeName}#"
    regimeCode            = "#{secret_billing-company-config_regimeCode}#"
    taxCode               = "#{secret_billing-company-config_taxCode}#"        # Escapar values .json: {\"...\"}
    email                 = "#{secret_billing-company-config_email}#"
    phone                 = "#{secret_billing-company-config_phone}#"
    address               = "#{secret_billing-company-config_address}#"        # Escapar values .json: {\"...\"}
  }
}
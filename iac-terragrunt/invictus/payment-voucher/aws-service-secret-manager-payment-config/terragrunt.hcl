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
  secret_name        = "billing-payment-config"
  secret_description = "Vendedor generico para factura electronica"
  secret_string_value = {
    paymentForm   = "#{secret_billing-payment-config_paymentForm}#"
    paymentMethod = "#{secret_billing-payment-config_paymentMethod}#"
  }
}
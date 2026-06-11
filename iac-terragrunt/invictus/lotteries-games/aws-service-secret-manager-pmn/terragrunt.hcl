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
  secret_name        = "pmn-national-association"
  secret_description = "Secretos para configuracion de central de productos nacionales"
  secret_string_value = {
    central_url    = "#{secret_pmn-national-association_central_url}#"
    id_product     = "#{secret_pmn-national-association_id_product}#"
    id_subcategory = "#{secret_pmn-national-association_id_subcategory}#"
    api_key        = "#{secret_pmn-national-association_api_key}#"
    code_company   = "#{secret_pmn-national-association_code_company}#"
  }
}
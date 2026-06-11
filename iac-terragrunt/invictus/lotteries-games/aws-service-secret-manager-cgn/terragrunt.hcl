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
  secret_name        = "cgn-national-association"
  secret_description = "Secreto chance goleador nacional"
  secret_string_value = {
    api_key        = "#{secret_cgn-national-association_api_key}#"
    central_url    = "#{secret_cgn-national-association_central_url}#"
    code_company   = "#{secret_cgn-national-association_code_company}#"
    id_product     = "#{secret_cgn-national-association_id_product}#"
    id_subcategory = "#{secret_cgn-national-association_id_subcategory}#"
  }
}
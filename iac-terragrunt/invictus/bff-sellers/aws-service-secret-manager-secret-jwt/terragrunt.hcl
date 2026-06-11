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
  secret_name        = "bff-secret"
  secret_description = "Secreto para validavion JWT"
  secret_string_value = {
    default_aes_key = "#{secret_bff-secret_default_aes_key}#"
    jwt_decrypt_key = "#{secret_bff-secret_jwt_decrypt_key}#"
  }
}

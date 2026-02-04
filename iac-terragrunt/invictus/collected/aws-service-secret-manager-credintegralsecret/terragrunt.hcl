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
  secret_name        = "credintegralsecret"
  secret_description = "Secreto de conexión a credintegralsecret"
  secret_string_value = {
    baseUrl  = "#{secret_credintegralsecret_baseUrl}#"
    username = "#{secret_credintegralsecret_username}#"
    password = "#{secret_credintegralsecret_password}#" #Tiene un / al final
  }
}
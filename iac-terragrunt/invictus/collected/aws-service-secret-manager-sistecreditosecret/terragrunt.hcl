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
  secret_name        = "sistecreditosecret"
  secret_description = "Secreto de conexión a sistecreditosecret"
  secret_string_value = {
    urlBase = "#{secret_sistecreditosecret_urlBase}#"
    key     = "#{secret_sistecreditosecret_key}#"
    timeout = "#{secret_sistecreditosecret_timeout}#"
  }
}
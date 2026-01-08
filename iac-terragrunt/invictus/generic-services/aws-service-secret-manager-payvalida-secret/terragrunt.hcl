include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs                  = {
  secret_name           = "payvalida-secret"
  secret_description    = "Secretos para conectarse a los servicios de payvalida en PDN"
  secret_string_value   = {
    url                 = "#{secret_payvalida-secret_url}#"
    urlt                = "#{secret_payvalida-secret_urlt}#"
  }
}
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
  secret_name        = "flypasssecret"
  secret_description = "Secreto para el producto de flypass"
  secret_string_value = {
    urlLogin          = "#{secret_flypasssecret_urlLogin}#"
    baseUrl           = "#{secret_flypasssecret_baseUrl}#"
    channel           = "#{secret_flypasssecret_channel}#"
    topeTransacciones = "#{secret_flypasssecret_topeTransacciones}#"
    timeout           = "#{secret_flypasssecret_timeout}#"
    clientId          = "#{secret_flypasssecret_clientId}#"
    username          = "#{secret_flypasssecret_username}#"
    password          = "#{secret_flypasssecret_password}#"
  }
}
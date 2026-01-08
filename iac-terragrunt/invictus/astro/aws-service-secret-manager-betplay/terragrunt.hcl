include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source  = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs = {
  secret_name           = "astrosecret"
  secret_description    = "datos de sesión con cem para microservicio de astro"
  secret_string_value   = {
    idUser              = "#{secret_astrosecret_idUser}#"
    password            = "#{secret_astrosecret_password}#"
    idCollaborator      = "#{secret_astrosecret_idCollaborator}#"
  }
}

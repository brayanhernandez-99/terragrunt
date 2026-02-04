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
  secret_name        = "betplaysecret"
  secret_description = "datos de sesión con cem para microservicio de online-games"
  secret_string_value = {
    idUser         = "#{secret_betplaysecret_idUser}#"
    password       = "#{secret_betplaysecret_password}#"
    idCollaborator = "#{secret_betplaysecret_idCollaborator}#"
  }
}

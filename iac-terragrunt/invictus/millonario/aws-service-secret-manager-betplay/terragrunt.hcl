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
  secret_name        = "millonariosecret"
  secret_description = "datos de sesión con cem para microservicio de millonario"
  secret_string_value = {
    idUser         = "#{secret_millonariosecret_idUser}#"
    password       = "#{secret_millonariosecret_password}#"
    idCollaborator = "#{secret_millonariosecret_idCollaborator}#"
  }
}
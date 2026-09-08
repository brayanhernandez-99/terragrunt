include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = basename(dirname(get_terragrunt_dir()))
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "secret_manager_transferimos" {
  config_path = "../aws-service-secret-manager-transferimos"
  mock_outputs = {
    secret_name = "secret-name"
  }
}

inputs = {
  ssm_parameters = {
    TRANSFERIMOS_SECRET = {
      type        = "String"
      name        = "/GLOBAL/TRANSFERIMOS_SECRET"
      value       = dependency.secret_manager_transferimos.outputs.secret_name
      description = "Nombre del secreto del aliado Transferimos"
    }
  }
}

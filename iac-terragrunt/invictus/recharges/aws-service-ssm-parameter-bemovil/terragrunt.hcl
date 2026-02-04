locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "secret_manager_bemovil" {
  config_path = "../aws-service-secret-manager-bemovil"
  mock_outputs = {
    secret_name = "mock-secret-name"
  }
}

inputs = {
  ssm_parameters = {
    BEMOVIL_SECRET = {
      type        = "String"
      name        = "/GLOBAL/BEMOVIL_SECRET"
      value       = "${dependency.secret_manager_bemovil.outputs.secret_name}"
      description = "Secreto de conexión de bemovil"
    }
    BEMOVIL_READ_TIMEOUT = {
      type        = "String"
      name        = "/GLOBAL/BEMOVIL_READ_TIMEOUT"
      value       = "30000"
      description = "Timeout de conexión de bemovil"
    }
  }
}
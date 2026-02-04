locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "secret_manager_conexred" {
  config_path = "../aws-service-secret-manager-conexred"
  mock_outputs = {
    secret_name = "mock-secret-name"
  }
}

dependency "secret_manager_cashin" {
  config_path = "../aws-service-secret-manager-cashin"
  mock_outputs = {
    secret_name = "mock-secret-name"
  }
}

dependency "secret_manager_pay" {
  config_path = "../aws-service-secret-manager-pay"
  mock_outputs = {
    secret_name = "mock-secret-name"
  }
}

dependency "secret_manager_recaudos" {
  config_path = "../aws-service-secret-manager-recaudos"
  mock_outputs = {
    secret_name = "mock-secret-name"
  }
}

dependency "secret_manager_conexred_pines" {
  config_path = "../aws-service-secret-manager-conexred-pines"
  mock_outputs = {
    secret_name = "mock-secret-name"
    secret_arn  = "mock-secret-arn"
  }
}

inputs = {
  ssm_parameters = {
    CONEXRED_SECRET = {
      type        = "String"
      name        = "/GLOBAL/CONEXRED_SECRET"
      value       = "${dependency.secret_manager_conexred.outputs.secret_name}"
      description = "Secreto de conexión de conexred"
    }
    CONEXRED_CASHIN_SECRET = {
      type        = "String"
      name        = "/GLOBAL/CONEXRED_CASHIN_SECRET"
      value       = "${dependency.secret_manager_cashin.outputs.secret_name}"
      description = "Nombre del secreto de cash-in"
    }
    CONEXRED_SECRET_PAY = {
      type        = "String"
      name        = "/GLOBAL/CONEXRED_SECRET_PAY"
      value       = "${dependency.secret_manager_pay.outputs.secret_name}"
      description = "Nombre del secreto de recaudo"
    }
    CONEXRED_COLLECTED_SECRET = {
      type        = "String"
      name        = "/GLOBAL/CONEXRED_COLLECTED_SECRET"
      value       = "${dependency.secret_manager_recaudos.outputs.secret_name}"
      description = "Nombre del secreto de recaudo"
    }
    CONEXRED_PIN_SECRET = {
      type        = "String"
      name        = "/GLOBAL/CONEXRED_PIN_SECRET"
      value       = split("secret:", dependency.secret_manager_conexred_pines.outputs.secret_arn)[1]
      description = "Nombre del secreto de pines"
    }
    CONEXRED_READ_TIMEOUT = {
      type        = "String"
      name        = "/GLOBAL/CONEXRED_READ_TIMEOUT"
      value       = "30000"
      description = "Timeout de conexión de conexred"
    }
  }
}
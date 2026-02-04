include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "cognito" {
  config_path = "../../initial-infrastructure/aws-service-cognito"
  mock_outputs = {
    user_pool_id = "mock_user_pool_id"
  }
}

inputs = {
  ssm_parameters = {
    KEY_URL = {
      type        = "String"
      name        = "/BFF_ADMIN/KEY_URL"
      value       = "https://cognito-idp.us-east-1.amazonaws.com/${dependency.cognito.outputs.user_pool_id}/.well-known/jwks.json"
      description = "URL de la llave pública de Cognito"
    }
    LOG_LEVEL = {
      type        = "String"
      name        = "/BFF_ADMIN/LOGLEVEL"
      value       = "#{parameter_log_level}#"
      description = "Nivel de log de BFF_ADMIN"
    }
    ADMIN_PUBLIC_URL = {
      type        = "String"
      name        = "/GLOBAL/ADMIN_PUBLIC_URL"
      value       = "#{parameter_admin_public_url}#"
      description = "Url para acceder a los servicios expuestos por el bff"
    }
    ADMIN_API_URL = {
      type        = "String"
      name        = "/GLOBAL/ADMIN_API_URL"
      value       = "#{parameter_admin_api_url}#"
      description = "Url para acceder a los servicios expuestos por el bff"
    }
  }
}
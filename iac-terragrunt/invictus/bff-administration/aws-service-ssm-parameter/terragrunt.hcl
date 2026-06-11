include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = basename(dirname(get_terragrunt_dir()))
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "cloudmap" {
  config_path = "../../initial-infrastructure/aws-service-cloudmap"
  mock_outputs = {
    cloudmap_namespace_name = "mock-cloudmap-namespace-name"
  }
}

dependency "cognito" {
  config_path = "../../initial-infrastructure/aws-service-cognito"
  mock_outputs = {
    user_pool_id = "mock_user_pool_id"
  }
}

inputs = {
  ssm_parameters = {
    PRODUCER_BASE_URL = {
      type        = "String"
      name        = "/GLOBAL/PRODUCER_${upper(local.service)}_BASE_URL"
      value       = "http://${local.service}.${dependency.cloudmap.outputs.cloudmap_namespace_name}:8080/"
      description = "Endpoint base del servicio expuesto a través de Cloudmap"
    }
    KEY_URL = {
      type        = "String"
      name        = "/BFF_ADMIN/KEY_URL"
      value       = "https://cognito-idp.#{aws_region}#.amazonaws.com/${dependency.cognito.outputs.user_pool_id}/.well-known/jwks.json"
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
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
    cloudmap_namespace_name = "namespace.local"
  }
}

dependency "secret_manager" {
  config_path = "../aws-service-secret-manager"
  mock_outputs = {
    secret_name = "secret-name"
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
    LOG_LEVEL = {
      type        = "String"
      name        = "/${upper(local.service)}/LOGLEVEL"
      value       = "#{parameter_log_level}#"
      description = "Nivel de log de ${local.service}"
    }
    DB_SECRET = {
      type        = "String"
      name        = "/${upper(local.service)}/DB_SECRET"
      value       = dependency.secret_manager.outputs.secret_name
      description = "Secreto de la base de datos de ${local.service}"
    }
    URL_LOAD_SECRET = {
      type        = "String"
      name        = "/${upper(local.service)}/URL_LOAD_SECRET"
      value       = "#{parameter_url_load_secret}#"
      description = "Default url mi post su red"
    }
  }
}
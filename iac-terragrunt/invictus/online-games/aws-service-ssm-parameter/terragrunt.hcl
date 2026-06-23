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
    cloudmap_namespace_name = "mock-namespace.local"
  }
}

dependency "secret_manager" {
  config_path = "../aws-service-secret-manager"
  mock_outputs = {
    secret_name = "mock-secret-name"
  }
}

dependency "secret_manager_betplay" {
  config_path = "../aws-service-secret-manager-betplay"
  mock_outputs = {
    secret_name = "mock-secret-name"
  }
}

inputs = {
  ssm_parameters = {
    PRODUCER_BASE_URL = {
      type        = "String"
      name        = "/GLOBAL/PRODUCER_${upper(replace(local.service, "-", "_"))}_BASE_URL"
      value       = "http://${local.service}.${dependency.cloudmap.outputs.cloudmap_namespace_name}:8080/"
      description = "Endpoint base del servicio expuesto a través de Cloudmap"
    }
    LOG_LEVEL = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/LOGLEVEL"
      value       = "#{parameter_log_level}#"
      description = "Nivel de log de ${local.service}"
    }
    DB_SECRET = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/DB_SECRET"
      value       = "${dependency.secret_manager.outputs.secret_name}"
      description = "Secreto de la base de datos de ${local.service}"
    }
    BETPLAY_SECRET_ONLINE_GAMES = {
      type        = "String"
      name        = "/GLOBAL/BETPLAY_SECRET"
      value       = "${dependency.secret_manager_betplay.outputs.secret_name}"
      description = "Parámetro para el secreto de betplay"
    }
    KINESIS_POLL_DELAY = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/KINESIS_POLL_DELAY"
      value       = "250"
      description = "kinesis poll delay"
    }
    KINESIS_LIMIT = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/KINESIS_LIMIT"
      value       = "10000"
      description = "Kinesis limit"
    }
    TIMEOUT_BETPLAY = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/TIMEOUT_BETPLAY"
      value       = "250"
      description = "Tiempo en milisegundos entre cada lectura a un stream"
    }
    ONLINE_GAMES_BUCKET_NAME = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/BUCKET_NAME"
      value       = "online-games-${get_aws_account_id()}"
      description = "name bucket online-games"
    }
  }
}
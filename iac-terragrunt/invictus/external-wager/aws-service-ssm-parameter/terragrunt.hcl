locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "ecs" {
  config_path = "../aws-service-ecs"
  mock_outputs = {
    listener_port = 0000
  }
}

dependency "load_balancer" {
  config_path = "../../initial-infrastructure/aws-service-load-balancer"
  mock_outputs = {
    nlb_dns_name = "mock-nlb-dns-name"
  }
}

dependency "secret_manager" {
  config_path = "../aws-service-secret-manager"
  mock_outputs = {
    secret_name = "mock-secret-name"
  }
}
dependency "secret_manager_balotosecret" {
  config_path = "../aws-service-secret-manager-balotosecret"
  mock_outputs = {
    secret_name = "mock-secret-name"
  }
}
dependency "secret_manager_colorlotosecret" {
  config_path = "../aws-service-secret-manager-colorlotosecret"
  mock_outputs = {
    secret_name = "mock-secret-name"
  }
}

inputs = {
  ssm_parameters = {
    PRODUCER_BASE_URL = {
      type        = "String"
      name        = "/GLOBAL/PRODUCER_${upper(replace(local.service, "-", "_"))}_BASE_URL"
      value       = "http://${dependency.load_balancer.outputs.nlb_dns_name}:${dependency.ecs.outputs.listener_port}/"
      description = "Configuración de máscaras de los logs"
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
    BALOTO_SECRET = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/BALOTO_SECRET"
      value       = "${dependency.secret_manager_balotosecret.outputs.secret_name}"
      description = "Nombre completo sin sufijo del secreto que contiene la información de la conexión a los servicios de baloto y miloto"
    }
    COLORLOTO_SECRET = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/COLORLOTO_SECRET"
      value       = "${dependency.secret_manager_colorlotosecret.outputs.secret_name}"
      description = "Nombre completo sin sufijo del secreto que contiene la información de la conexión a los servicios de colorloto"
    }
    EXPIRATION_FILE = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/EXPIRATION_FILE"
      value       = "86400"
      description = "Tiempo en mili-segundos que durara el cache"
    }
    KINESIS_POLL_DELAY = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/KINESIS_POLL_DELAY"
      value       = "500"
      description = "kinesis poll delay"
    }
    KINESIS_LIMIT = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/KINESIS_LIMIT"
      value       = "10000"
      description = "Kinesis limit"
    }
    EXTERNAL_WAGER_BUCKET_NAME = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/BUCKET_NAME"
      value       = "external-wager-${get_aws_account_id()}"
      description = "name bucket external-wager"
    }
  }
}
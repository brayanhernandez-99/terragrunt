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

dependency "eventbridge_scheduler" {
  config_path = "../aws-service-iam-scheduler-rol"
  mock_outputs = {
    iam_role_name = "iam-role"
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
      value       = dependency.secret_manager.outputs.secret_name
      description = "Secreto de la base de datos de ${local.service}"
    }
    IDE_EMPRESA = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/IDE_EMPRESA"
      value       = "#{parameter_ide_empresa}#"
      description = "Identificador de empresa"
    }
    SCHEDULE_ROL = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/SCHEDULE_ROL"
      value       = dependency.eventbridge_scheduler.outputs.iam_role_name
      description = "Parámetro de schedule rol"
    }
    BILLETON_MAX_REPEAT = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/BILLETON_MAX_REPEAT"
      value       = "#{parameter_billeton_max_repeat}#"
      description = "Cantidad maxima de repeticiones en los productos de tipo chance con mezcla"
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
    LOTTERIES_GAMES_BUCKET_NAME = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/BUCKET_NAME"
      value       = "lotteries-games-documents-${get_aws_account_id()}"
      description = "name bucket lotteries-games"
    }
    LOG_BLACKLIST_ENDPOINTS = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/LOG_BLACKLIST_ENDPOINTS"
      value       = "/chances/image/lottery,/products/get-product"
      description = "Lista negra de endpoints que no guardan logs en el servicio"
    }
  }
}
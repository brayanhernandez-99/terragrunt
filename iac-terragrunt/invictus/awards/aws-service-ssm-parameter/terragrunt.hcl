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

dependency "iam_role" {
  config_path = "../../initial-infrastructure/aws-service-event-bridge/event-bridge-iam-role"
  mock_outputs = {
    role_name = "iam-role"
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
    MAIN_COMPANY_ID = {
      type        = "String"
      name        = "/${upper(local.service)}/MAIN_COMPANY_ID"
      value       = "#{parameter_main_company_id}#"
      description = "Id de la empresa principal"
    }
    SCHEDULE_ROL = {
      type        = "String"
      name        = "/${upper(local.service)}/SCHEDULE_ROL"
      value       = dependency.iam_role.outputs.role_name
      description = "Nombre del IAM Role"
    }
    AWARDS_BUCKET_NAME = {
      type        = "String"
      name        = "/${upper(local.service)}/BUCKET_NAME"
      value       = "awards-${get_aws_account_id()}"
      description = "name bucket astro"
    }
    AWARDS_VIEW_PARAMETER_STORE = {
      type        = "String"
      name        = "/${upper(local.service)}/VIEW/PARAMETER/STORE"
      value       = "N"
      description = "Esta variable sirve para darle vista a los campos del sorteo que estan enmascarados una ves ingresados"
    }
  }
}

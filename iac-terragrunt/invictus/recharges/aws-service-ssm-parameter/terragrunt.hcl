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

dependency "secret_manager_flypass" {
  config_path = "../aws-service-secret-manager-flypass"
  mock_outputs = {
    secret_name = "secret-name"
  }
}

dependency "secret_manager_conexred" {
  config_path = "../aws-service-secret-manager-conexred"
  mock_outputs = {
    secret_name = "secret-name"
  }
}

dependency "secret_manager_cashin" {
  config_path = "../aws-service-secret-manager-cashin"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_manager_pay" {
  config_path = "../aws-service-secret-manager-pay"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_manager_recaudos" {
  config_path = "../aws-service-secret-manager-recaudos"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_manager_conexred_pines" {
  config_path = "../aws-service-secret-manager-conexred-pines"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_manager_bemovil" {
  config_path = "../aws-service-secret-manager-bemovil"
  mock_outputs = {
    secret_name = "secret-name"
  }
}

dependency "secret_manager_transferimos" {
  config_path = "../aws-service-secret-manager-transferimos"
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
    ENABLE_ENDPOINT_MOCK = {
      type        = "String"
      name        = "/GLOBAL/ENABLE_ENDPOINT_MOCK"
      value       = "#{parameter_enable_endpoint_mock}#"
      description = "Activar o desactivar el mock de la api"
    }
    ENDPOINT_MOCK_API_URL = {
      type        = "String"
      name        = "/GLOBAL/ENDPOINT_MOCK_API_URL"
      value       = "#{parameter_sellers_api_url}#"
      description = "Url del mock de la api"
    }
    FLYPASS_SECRET = {
      type        = "String"
      name        = "/${upper(local.service)}/FLYPASS_SECRET"
      value       = dependency.secret_manager_flypass.outputs.secret_name
      description = "Nombre del secreto de la informacion de autenticacion con Flypass"
    }
    CONEXRED_SECRET = {
      type        = "String"
      name        = "/GLOBAL/CONEXRED_SECRET"
      value       = dependency.secret_manager_conexred.outputs.secret_name
      description = "Secreto de conexión de conexred"
    }
    CONEXRED_CASHIN_SECRET = {
      type        = "String"
      name        = "/GLOBAL/CONEXRED_CASHIN_SECRET"
      value       = split("secret:", dependency.secret_manager_cashin.outputs.secret_arn)[1]
      description = "Nombre del secreto de cash-in"
    }
    CONEXRED_SECRET_PAY = {
      type        = "String"
      name        = "/GLOBAL/CONEXRED_SECRET_PAY"
      value       = split("secret:", dependency.secret_manager_pay.outputs.secret_arn)[1]
      description = "Nombre del secreto de recaudo"
    }
    CONEXRED_COLLECTED_SECRET = {
      type        = "String"
      name        = "/GLOBAL/CONEXRED_COLLECTED_SECRET"
      value       = split("secret:", dependency.secret_manager_recaudos.outputs.secret_arn)[1]
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
    BEMOVIL_SECRET = {
      type        = "String"
      name        = "/GLOBAL/BEMOVIL_SECRET"
      value       = dependency.secret_manager_bemovil.outputs.secret_name
      description = "Secreto de conexión de bemovil"
    }
    BEMOVIL_READ_TIMEOUT = {
      type        = "String"
      name        = "/GLOBAL/BEMOVIL_READ_TIMEOUT"
      value       = "30000"
      description = "Timeout de conexión de bemovil"
    }
    TRANSFERIMOS_SECRET = {
      type        = "String"
      name        = "/GLOBAL/TRANSFERIMOS_SECRET"
      value       = dependency.secret_manager_transferimos.outputs.secret_name
      description = "Nombre del secreto del aliado Transferimos"
    }
    KINESIS_POLL_DELAY = {
      type        = "String"
      name        = "/${upper(local.service)}/KINESIS_POLL_DELAY"
      value       = "750"
      description = "kinesis poll delay"
    }
    KINESIS_LIMIT = {
      type        = "String"
      name        = "/${upper(local.service)}/KINESIS_LIMIT"
      value       = "10000"
      description = "Kinesis limit"
    }
    RECHARGES_BUCKET_NAME = {
      type        = "String"
      name        = "/${upper(local.service)}/BUCKET_NAME"
      value       = "recharges-documents-${get_aws_account_id()}"
      description = "name bucket recharges"
    }
  }
}
locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "ecs"                           {
  config_path                              = "../aws-service-ecs"
  mock_outputs                             = {
    listener_port                          = 0000
  }
}

dependency "load_balancer"                 {
  config_path                              = "../../initial-infrastructure/aws-service-load-balancer"
  mock_outputs                             = {
    nlb_dns_name                           = "mock-nlb-dns-name"
  }
}

dependency "secret_manager"                {
  config_path                              = "../aws-service-secret-manager"
  mock_outputs                             = {
    secret_name                            = "mock-secret-name"
  }
}

dependency "secret_manager_conexred"       {
  config_path                              = "../aws-service-secret-manager-conexred"
  mock_outputs                             = {
    secret_name                            = "mock-secret-name"
  }
}

dependency "secret_manager_bemovil"        {
  config_path                              = "../aws-service-secret-manager-bemovil"
  mock_outputs                             = {
    secret_name                            = "mock-secret-name"
  }
}

dependency "secret_manager_cashin"         {
  config_path                              = "../aws-service-secret-manager-cashin"
  mock_outputs                             = {
    secret_name                            = "mock-secret-name"
  }
}

dependency "secret_manager_recaudos"       {
  config_path                              = "../aws-service-secret-manager-recaudos"
  mock_outputs                             = {
    secret_name                            = "mock-secret-name"
  }
}

dependency "secret_manager_conexred_pines" {
  config_path                              = "../aws-service-secret-manager-conexred-pines"
  mock_outputs                             = {
    secret_name                            = "mock-secret-name"
    secret_arn                             = "mock-secret-arn"
  }
}

dependency "secret_manager_funds"          {
  config_path                              = "../../initial-infrastructure/aws-service-secret-manager-funds"
  mock_outputs                             = {
    secret_name                            = "mock-secret-name"
  }
}

dependency "secret_manager_flypass"        {
  config_path                              = "../aws-service-secret-manager-flypass"
  mock_outputs                             = {
    secret_name                            = "mock-secret-name"
  }
}

dependency "secret_manager_pay"        {
  config_path                              = "../aws-service-secret-manager-pay"
  mock_outputs                             = {
    secret_name                            = "mock-secret-name"
  }
}

inputs                                     = {
  ssm_parameters                           = {
    PRODUCER_BASE_URL                      = {
      type                                 = "String"
      name                                 = "/GLOBAL/PRODUCER_${upper(local.service)}_BASE_URL"
      value                                = "http://${dependency.load_balancer.outputs.nlb_dns_name}:${dependency.ecs.outputs.listener_port}/"
      description                          = "Configuración de máscaras de los logs"
    }
    LOG_LEVEL                              = {
      type                                 = "String"
      name                                 = "/${upper(local.service)}/LOGLEVEL"
      value                                = "#{parameter_log_level}#"
      description                          = "Nivel de log de ${local.service}"
    }
    DB_SECRET                              = {
      type                                 = "String"
      name                                 = "/${upper(local.service)}/DB_SECRET"
      value                                = "${dependency.secret_manager.outputs.secret_name}"
      description                          = "Secreto de la base de datos de ${local.service}"
    }
    CONEXRED_SECRET                        = {
      type                                 = "String"
      name                                 = "/GLOBAL/CONEXRED_SECRET"
      value                                = "${dependency.secret_manager_conexred.outputs.secret_name}"
      description                          = "Secreto de conexión de conexred"
    }
    CONEXRED_CASHIN_SECRET                 = {
      type                                 = "String"
      name                                 = "/GLOBAL/CONEXRED_CASHIN_SECRET"
      value                                = "${dependency.secret_manager_cashin.outputs.secret_name}"
      description                          = "Nombre del secreto de cash-in"
    }
    CONEXRED_SECRET_PAY                    = {
      type                                 = "String"
      name                                 = "/GLOBAL/CONEXRED_SECRET_PAY"
      value                                = "${dependency.secret_manager_pay.outputs.secret_name}"
      description                          = "Nombre del secreto de recaudo"
    }
    CONEXRED_COLLECTED_SECRET              = {
      type                                 = "String"
      name                                 = "/GLOBAL/CONEXRED_COLLECTED_SECRET"
      value                                = "${dependency.secret_manager_recaudos.outputs.secret_name}"
      description                          = "Nombre del secreto de recaudo"
    }
    CONEXRED_PIN_SECRET                    = {
      type                                 = "String"
      name                                 = "/GLOBAL/CONEXRED_PIN_SECRET"
      value                                = split("secret:", dependency.secret_manager_conexred_pines.outputs.secret_arn)[1]
      description                          = "Nombre del secreto de pines"
    }
    CONEXRED_READ_TIMEOUT                  = {
      type                                 = "String"
      name                                 = "/GLOBAL/CONEXRED_READ_TIMEOUT"
      value                                = "30000"
      description                          = "Timeout de conexión de conexred"
    }
    BEMOVIL_SECRET                         = {
      type                                 = "String"
      name                                 = "/GLOBAL/BEMOVIL_SECRET"
      value                                = "${dependency.secret_manager_bemovil.outputs.secret_name}"
      description                          = "Secreto de conexión de bemovil"
    }
    BEMOVIL_READ_TIMEOUT                   = {
      type                                 = "String"
      name                                 = "/GLOBAL/BEMOVIL_READ_TIMEOUT"
      value                                = "30000"
      description                          = "Timeout de conexión de bemovil"
    }
    ENABLE_ENDPOINT_MOCK                   = {
      type                                 = "String"
      name                                 = "/GLOBAL/ENABLE_ENDPOINT_MOCK"
      value                                = "#{parameter_enable_endpoint_mock}#"
      description                          = "Activar o desactivar el mock de la api"
    }
    ENDPOINT_MOCK_API_URL                  = {
      type                                 = "String"
      name                                 = "/GLOBAL/ENDPOINT_MOCK_API_URL"
      value                                = "#{parameter_sellers_api_url}#"
      description                          = "Url del mock de la api"
    }
    FLYPASS_SECRET                         = {
      type                                 = "String"
      name                                 = "/${upper(local.service)}/FLYPASS_SECRET"
      value                                = "${dependency.secret_manager_flypass.outputs.secret_name}"
      description                          = "Nombre del secreto de la informacion de autenticacion con Flypass"
    }
    KINESIS_POLL_DELAY                     = {
      type                                 = "String"
      name                                 = "/${upper(local.service)}/KINESIS_POLL_DELAY"
      value                                = "750"
      description                          = "kinesis poll delay"
    }
    KINESIS_LIMIT                          = {
      type                                 = "String"
      name                                 = "/${upper(local.service)}/KINESIS_LIMIT"
      value                                = "10000"
      description                          = "Kinesis limit"
    }
    RECHARGES_BUCKET_NAME                  = {
      type                                 = "String"
      name                                 = "/${upper(local.service)}/BUCKET_NAME"
      value                                = "recharges-documents-${get_aws_account_id()}"
      description                          = "name bucket recharges"
    }
  }
}
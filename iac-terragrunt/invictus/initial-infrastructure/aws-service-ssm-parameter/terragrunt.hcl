include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "cognito"              {
  config_path                     = "../../initial-infrastructure/aws-service-cognito"
  mock_outputs                    = {
    user_pool_id                  = "mock_user_pool_id"
  }
}

dependency "s3"                   {
  config_path                     = "../../initial-infrastructure/aws-service-s3"
  mock_outputs                    = {
    s3_bucket_domain_name         = "mock_bucket_domain_name"
  }
}

dependency "s3_repo_config"       {
  config_path                     = "../../initial-infrastructure/aws-service-s3-repository-configuration"
  mock_outputs                    = {
    s3_bucket_domain_name         = "mock_bucket_domain_name"
  }
}

dependency "secret_manager"       {
  config_path                     = "../aws-service-secret-manager"
  mock_outputs                    = {
    secret_name                   = "mock-secret-name"
  }
}

dependency "secret_manager_funds" {
  config_path                     = "../aws-service-secret-manager-funds"
  mock_outputs                    = {
    secret_name                   = "mock-secret-name"
  }
}

dependency "secret_manager_aes"   {
  config_path                     = "../aws-service-secret-manager-aes"
  mock_outputs                    = {
    secret_name                   = "mock-secret-name"
  }
}

dependency "dynamo_ckm"   {
  config_path                     = "../aws-service-dynamo-ckm"
  mock_outputs                    = {
    kms_key_id                   = "mock-kms-key-id"
  }
}

dependency "rds_ckm"   {
  config_path                     = "../aws-service-rds-ckm"
  mock_outputs                    = {
    kms_key_id                   = "mock-kms-key-id"
  }
}

dependency "secrets_ckm"   {
  config_path                     = "../aws-service-secrets-ckm"
  mock_outputs                    = {
    kms_key_id                   = "mock-kms-key-id"
  }
}

inputs = {
  ssm_parameters                  = {
    ACCOUNT_NUMBER                = {
      type                        = "String"
      name                        = "/GLOBAL/ACCOUNT_NUMBER"
      value                       = "${get_aws_account_id()}"
      description                 = "Número de cuenta de AWS"
    }
    SELLERS_USER_POOL_ID          = {
      type                        = "String"
      name                        = "/GLOBAL/SELLERS_USER_POOL_ID"
      value                       = "${dependency.cognito.outputs.user_pool_id}"
      description                 = "User Pool ID de Cognito"
    }
    ADMIN_USER_POOL_ID            = {
      type                        = "String"
      name                        = "/GLOBAL/ADMIN_USER_POOL_ID"
      value                       = "${dependency.cognito.outputs.user_pool_id}"
      description                 = "User Pool ID de Cognito"
    }
    SELLERS_USER_POOL_CLIENT_ID   = {
      type                        = "String"
      name                        = "/GLOBAL/SELLERS_USER_POOL_CLIENT_ID"
      value                       = "#{parameter_sellers_user_pool_client_id}#" #varia segun el ambiente (Cognito/Identity pools/User access/Identity providers/Client ID)
      description                 = "User Pool client ID de Cognito"
    }
    ADMIN_USER_POOL_CLIENT_ID     = {
      type                        = "String"
      name                        = "/GLOBAL/ADMIN_USER_POOL_CLIENT_ID"
      value                       = "#{parameter_admin_user_pool_client_id}#" #varia segun el ambiente (Cognito/Identity pools/User access/Identity providers/Client ID)
      description                 = "User Pool client ID de Cognito"
    }
    FILES_BUCKET_EXPIRATION       = {
      type                        = "String"
      name                        = "/GLOBAL/FILES_BUCKET_EXPIRATION"
      value                       = "86400"
      description                 = "Archivo de expiración de bucket"
    }
    BUCKET_CERTS                  = {
      type                        = "String"
      name                        = "/GLOBAL/BUCKET_CERTS"
      value                       = dependency.s3.outputs.s3_bucket_name
      description                 = "Bucket de certificados"
    }
    HOST_IOT                      = {
      type                        = "String"
      name                        = "/GLOBAL/HOST_IOT"
      value                       = "#{parameter_host_iot}#" # varia segun el ambiente (IoT Core/MQTT test client/Connection details/Endpoint)
      description                 = "Host de IoT"
    }
    TIME_ZONE                     = {
      type                        = "String"
      name                        = "/GLOBAL/TIME_ZONE"
      value                       = "America/Bogota"
      description                 = "Zona horaria"
    }
    MASK_CONFIG                   = {
      type                        = "String"
      name                        = "/GLOBAL/MASKCONFIG"
      value                       = jsonencode(jsondecode(file("./mask_config.json")))
      description                 = "Configuración de máscaras de los logs"
    }
    MI_POS_SECRET                 = {
      type                        = "String"
      name                        = "/GLOBAL/MIPOS_SECRET"
      value                       = "${dependency.secret_manager.outputs.secret_name}"
      description                 = "Secreto de MI POS"
    }
    FUNDS_SECRET                  = {
      type                        = "String"
      name                        = "/GLOBAL/FUNDS_SECRET"
      value                       = "${dependency.secret_manager_funds.outputs.secret_name}"
      description                 = "Secreto de Fondos"
    }
    SELLERS_IDENTITY_POOL_ID      = {
      type                        = "String"
      name                        = "/GLOBAL/SELLERS_IDENTITY_POOL_ID"
      value                       = "#{parameter_sellers_identity_pool_id}#" #varia segun el ambiente (Cognito/Identity pools/Identity pool ID)
      description                 = "Secreto de Fondos"
    }
    KEY_AES                       = {
      type                        = "String"
      name                        = "/GLOBAL/KEYAES"
      value                       = "${dependency.secret_manager_aes.outputs.secret_name}"
      description                 = "Secreto de Fondos"
    }
    KMS_KINESIS                   = {
      type                        = "String"
      name                        = "/GLOBAL/KMS_KINESIS"
      value                       = "#{parameter_kms_kinesis}#" #varia segun el ambiente (KMS/Customer managed keys/Key ID)
      description                 = "Id de la llave de encripción para kinesis"
    }
    KMS_DYNAMO                    = {
      type                        = "String"
      name                        = "/GLOBAL/KMS_DYNAMO"
      value                       = "${dependency.dynamo_ckm.outputs.kms_key_id}" #varia segun el ambiente (KMS/Customer managed keys/Key ID)
      description                 = "Id de la llave de encripción para dynamo"
    }
    KMS_RDS                    = {
      type                        = "String"
      name                        = "/GLOBAL/KMS_RDS"
      value                       = "${dependency.rds_ckm.outputs.kms_key_id}" #varia segun el ambiente (KMS/Customer managed keys/Key ID)
      description                 = "Id de la llave de encripción para rds"
    }
    KMS_SECRETS                   = {
      type                        = "String"
      name                        = "/GLOBAL/KMS_SECRETS"
      value                       = "${dependency.secrets_ckm.outputs.kms_key_id}" #varia segun el ambiente (KMS/Customer managed keys/Key ID)
      description                 = "Id de la llave de encripción para secrets"
    }
    IP_SOCKET_CEM                 = {
      type                        = "String"
      name                        = "/GLOBAL/IP_SOCKET_CEM"
      value                       = "#{parameter_ip_socket_cem}#"
      description                 = "Endpoint de servicios CEM"
    }
    PORT_SOCKET_CEM               = {
      type                        = "String"
      name                        = "/GLOBAL/PORT_SOCKET_CEM"
      value                       = "#{parameter_port_socket_cem}#"
      description                 = "Puerto de servicios CEM"
    }
    BETPLAY_READ_TIMEOUT          = {
      type                        = "String"
      name                        = "/GLOBAL/BETPLAY_READ_TIMEOUT"
      value                       = "65000" 
      description                 = "Timeout de lectura de Betplay"
    }
    EMAIL_ERROR                   = {
      type                        = "String"
      name                        = "/GLOBAL/EMAIL_ERROR"
      value                       = "produccioninvictus@gmail.com" 
      description                 = "Email donde se enviarán los errores detectados en la plataforma despues de sus reintentos"
    }
    SWITCH_TRANSACTION_CAPS       = {
      type                        = "String"
      name                        = "/GLOBAL/SWITCH_TRANSACTION_CAPS"
      value                       = "false"
      description                 = "Parametro que indica si se activa la validación de topes en Invictus en ms-transaction"
    }
    SWITCH_COMMISSION_PLAN        = {
      type                        = "String"
      name                        = "/GLOBAL/SWITCH_COMMISSION_PLAN"
      value                       = "false"
      description                 = "Parametro que indica si se activa la validación de comisiones en Invictus en ms-transaction"
    }
    TIMEOUT_CEM                   = {
      type                        = "String"
      name                        = "/GLOBAL/TIMEOUT_CEM"
      value                       = "60000"
      description                 = "timeout cem"
    }
    CONFIGURATION_BUCKET_NAME     = {
      type                        = "String"
      name                        = "/GLOBAL/CONFIGURATION_BUCKET_NAME"
      value                       = "${dependency.s3_repo_config.outputs.s3_bucket_name}"
      description                 = "El bucket para la configuración de todos los dominios"
    }
    ENABLE_VIRTUAL_SEQUENCE       = {
      type                        = "String"
      name                        = "/GLOBAL/ENABLE_VIRTUAL_SEQUENCE"
      value                       = "false"
      description                 = "Parametro que activa la secuencia de papeleria virtual"
    }
    SIGA                          = {
      type                        = "String"
      name                        = "/GLOBAL/SIGA"
      value                       = jsonencode(jsondecode(file("./parameters/#{parameter_siga}#")))
      description                 = "Se configura aquellos productos que deben replicar a siga"
    }
    PRISMA2_SECURITY_BASE_URL     = {
      type                        = "String"
      name                        = "/GLOBAL/PRISMA2_SECURITY_BASE_URL"
      value                       = "#{parameter_prisma2_security_base_url}#"
      description                 = "Url base en Prisma 2 para realizar el proceso de autenticación"
    }
    PRISMA2_TRANSUNION_BASE_URL   = {
      type                        = "String"
      name                        = "/GLOBAL/PRISMA2_TRANSUNION_BASE_URL"
      value                       = "#{parameter_prisma2_transunion_base_url}#"
      description                 = "Url base en Prisma 2 para consumir los servicios de transunion"
    }
    PRISMA2_SARLAFT_BASE_URL      = {
      type                        = "String"
      name                        = "/GLOBAL/PRISMA2_SARLAFT_BASE_URL"
      value                       = "#{parameter_prisma2_sarlaft_base_url}#"
      description                 = "Url base en Prisma 2 para consumir los servicios de sarlaft"
    }
    PRISMA2_MI_SMS_BASE_URL       = {
      type                        = "String"
      name                        = "/GLOBAL/PRISMA2_MI_SMS_BASE_URL"
      value                       = "#{parameter_prisma2_mi_sms_base_url}#"
      description                 = "Url base en Prisma 2 para consumir los servicios de SMS"
    }
    PRISMA2_MI_EMAIL_BASE_URL     = {
      type                        = "String"
      name                        = "/GLOBAL/PRISMA2_MI_EMAIL_BASE_URL"
      value                       = "#{parameter_prisma2_mi_email_base_url}#"
      description                 = "Url base en Prisma 2 para consumir los servicios de email"
    }
    PRISMA2_EMAIL_TEMPLATE_NAME   = {
      type                        = "String"
      name                        = "/GLOBAL/PRISMA2_EMAIL_TEMPLATE_NAME"
      value                       = "#{parameter_prisma2_email_template_name}#"
      description                 = "Nombre de la plantilla en Prisma 2 a utilizarse para el envío de correos. Debe pertenecer a la aplicación configurada en el parámetro PRISMA2_EMAIL_APPLICATION"
    }
    PRISMA2_EMAIL_APPLICATION     = {
      type                        = "String"
      name                        = "/GLOBAL/PRISMA2_EMAIL_APPLICATION"
      value                       = "#{parameter_prisma2_email_application}#"
      description                 = "Nombre de la plantilla en Prisma 2 a utilizarse para el envío de correos. Debe pertenecer a la aplicación configurada en el parámetro PRISMA2_EMAIL_APPLICATION"
    }
    PRISMA2_APPLICATION           = {
      type                        = "String"
      name                        = "/GLOBAL/PRISMA2_APPLICATION"
      value                       = "#{parameter_prisma2_application}#"
      description                 = "Código de la aplicación en el ecosistema Prisma 2 con el que se autenticará para consumir sus servicios"
    }
    BUSINESS_NIT                  = {
      type                        = "String"
      name                        = "/GLOBAL/BUSINESS_NIT"
      value                       = "#{parameter_business_nit}#"
      description                 = "Nit de la empresa cliente"
    }
    BUSINESS_NIT                  = {
      type                        = "String"
      name                        = "/GLOBAL/BUSINESS_TYPE"
      value                       = "#{parameter_business_type}#"
      description                 = "Tipo de empresa cliente"
    }
    BUSINESS_NAME                 = {
      type                        = "String"
      name                        = "/GLOBAL/BUSINESS_NAME"
      value                       = "#{parameter_business_name}#"
      description                 = "Nombre de la empresa cliente"
    }
    BUSINESS_ADDRESS              = {
      type                        = "String"
      name                        = "/GLOBAL/BUSINESS_ADDRESS"
      value                       = "#{parameter_business_address}#"
      description                 = "Dirección de la empresa cliente"
    }
    GLOBAL_FILES_BUCKET_NAME      = {
      type                        = "String"
      name                        = "/GLOBAL/FILES_BUCKET_NAME"
      value                       = "files-${get_aws_account_id()}"
      description                 = "El bucket para almacenar archivos temporales que serán descargados posterior a su creación"
    }
  }
}

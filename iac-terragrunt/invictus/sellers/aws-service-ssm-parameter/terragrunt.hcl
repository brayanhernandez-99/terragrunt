locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "ecs"                 {
  config_path                    = "../aws-service-ecs"
  mock_outputs                   = {
    listener_port                = 0000
  }
}

dependency "load_balancer"       {
  config_path                    = "../../initial-infrastructure/aws-service-load-balancer"
  mock_outputs                   = {
    nlb_dns_name                 = "mock-nlb-dns-name"
  }
}

dependency "secret_manager"      {
  config_path                    = "../aws-service-secret-manager"
  mock_outputs                   = {
    secret_name                  = "mock-secret-name"
  }
}

inputs                           = {
  ssm_parameters                 = {
    PRODUCER_BASE_URL            = {
      type                       = "String"
      name                       = "/GLOBAL/PRODUCER_${upper(local.service)}_BASE_URL"
      value                      = "http://${dependency.load_balancer.outputs.nlb_dns_name}:${dependency.ecs.outputs.listener_port}/"
      description                = "Configuración de máscaras de los logs"
    }
    LOG_LEVEL                    = {
      type                       = "String"
      name                       = "/${upper(local.service)}/LOGLEVEL"
      value                      = "#{parameter_log_level}#"
      description                = "Nivel de log de ${local.service}"
    }
    DB_SECRET                    = {
      type                       = "String"
      name                       = "/${upper(local.service)}/DB_SECRET"
      value                      = "${dependency.secret_manager.outputs.secret_name}"
      description                = "Secreto de la base de datos de ${local.service}"
    }
    METABASE_URL                 = {
      type                       = "String"
      name                       = "/${upper(local.service)}/METABASE_URL"
      value                      = "#{parameter_metabase_url}#"
      description                = "Secreto de la base de datos de ${local.service}"
    }
    METABASE_API_KEY             = {
      type                       = "String"
      name                       = "/${upper(local.service)}/METABASE_API_KEY"
      value                      = "#{parameter_metabase_api_key}#"
      description                = "Secreto de la base de datos de ${local.service}"
    }
    METABASE_EMBEDDED_SECRET_KEY = {
      type                       = "String"
      name                       = "/${upper(local.service)}/METABASE_EMBEDDED_SECRET_KEY"
      value                      = "#{parameter_metabase_embedded_secret_key}#"
      description                = "Secreto de la base de datos de ${local.service}"
    }
    SELLER_TYPE                  = {
      type                       = "String"
      name                       = "/${upper(local.service)}/SELLER_TYPE"
      value                      = "#{parameter_seller_type}#"
      description                = "Tipo de liquidación de un vendedor. Puede ser Prepago o Postpago"
    }
    SELLERS_CONFLUENCE_API_KEY   = {
      type                       = "String"
      name                       = "/${upper(local.service)}/CONFLUENCE_API_KEY"
      value                      = "#{parameter_sellers_confluence_api_key}#"
      description                = "CONFLUENCE API KEY"
    }
    SELLERS_CONFLUENCE_EMAIL     = {
      type                       = "String"
      name                       = "/${upper(local.service)}/CONFLUENCE_EMAIL"
      value                      = "invictus.confluence@ux.technology"
      description                = "CONFLUENCE EMAIL"
    }
    EXPIRATION_MASSIVE_FILE      = {
      type                       = "String"
      name                       = "/${upper(local.service)}/EXPIRATION_MASSIVE_FILE"
      value                      = "604800"
      description                = "Tiempo en segundos que durará el link generado para descargar el archivo de cargas masivas"
    }
    CONFLUENCE_URL               = {
      type                       = "String"
      name                       = "/${upper(local.service)}/CONFLUENCE_URL"
      value                      = "https://uxtechnology.atlassian.net"
      description                = "URL para acceder a confluence"
    }
    MAX_SELLER_BALANCE           = {
      type                       = "String"
      name                       = "/${upper(local.service)}/MAX_SELLER_BALANCE"
      value                      = "1000000"
      description                = "Tope máximo de ventas que un vendedor puede realizar en un día"
    }
    KINESIS_POLL_DELAY           = {
      type                       = "String"
      name                       = "/${upper(local.service)}/KINESIS_POLL_DELAY"
      value                      = "750"
      description                = "kinesis poll delay"
    }
    KINESIS_LIMIT                = {
      type                       = "String"
      name                       = "/${upper(local.service)}/KINESIS_LIMIT"
      value                      = "10000"
      description                = "Kinesis limit"
    }
    SELLERS_BUCKET_NAME          = {
      type                       = "String"
      name                       = "/${upper(local.service)}/BUCKET_NAME"
      value                      = "sellers-documents-${get_aws_account_id()}"
      description                = "name bucket sellers"
    }
  }
}
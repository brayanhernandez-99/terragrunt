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
  config_path         = "../aws-service-ecs"
  mock_outputs        = {
    listener_port     = 0000
  }
}

dependency "load_balancer" {
  config_path         = "../../initial-infrastructure/aws-service-load-balancer"
  mock_outputs        = {
    nlb_dns_name      = "mock-nlb-dns-name"
  }
}

dependency "secret_manager"        {
  config_path                      = "../aws-service-secret-manager"
  mock_outputs                     = {
    secret_name                    = "mock-secret-name"
  }
}

dependency "secret_manager_funds"  {
  config_path                      = "../../initial-infrastructure/aws-service-secret-manager-funds"
  mock_outputs                     = {
    secret_name                    = "mock-secret-name"
  }
}

dependency "eventbridge_scheduler" {
  config_path                      = "../aws-service-iam-scheduler-rol"
  mock_outputs                     = {
    iam_role_name                  = "mock-iam-role-name"
  }
}

inputs                    = {
  ssm_parameters          = {
    PRODUCER_BASE_URL     = {
      type                = "String"
      name                = "/GLOBAL/PRODUCER_${upper(local.service)}_BASE_URL"
      value               = "http://${dependency.load_balancer.outputs.nlb_dns_name}:${dependency.ecs.outputs.listener_port}/"
      description         = "Configuración de máscaras de los logs"
    }
    LOG_LEVEL             = {
      type                = "String"
      name                = "/${upper(local.service)}/LOGLEVEL"
      value               = "#{parameter_log_level}#"
      description         = "Nivel de log de ${local.service}"
    },
    DB_SECRET             = {
      type                = "String"
      name                = "/${upper(local.service)}/DB_SECRET"
      value               = "${dependency.secret_manager.outputs.secret_name}"
      description         = "Secreto de la base de datos de ${local.service}"
    },
    SELLER_RETENTION_PERCENTAGE = {
      type                = "String"
      name                = "/${upper(local.service)}/SELLER_RETENTION_PERCENTAGE"
      value               = "#{parameter_seller_retention_percentage}#"
      description         = "Porcentaje de retención vendedor"
    }
    SELLER_DISCOUNT       = {
      type                = "String"
      name                = "/${upper(local.service)}/SELLER_DISCOUNT"
      value               = "#{parameter_seller_discount}#"
      description         = "Descuento del vendedor"
    }
    FUNDS_SECRET          = {
      type                = "String"
      name                = "/${upper(local.service)}/FUNDS_SECRET"
      value               = "${dependency.secret_manager_funds.outputs.secret_name}"
      description         = "Nombre del secreto donde se encuentran las semillas para el calculo del hash para validar los saldos de los vendedores"
    }
    SELLER_TAX_PERCENTAGE = {
      type                = "String"
      name                = "/${upper(local.service)}/SELLER_TAX_PERCENTAGE"
      value               = "#{parameter_seller_tax_percentage}#"
      description         = "Porcentaje de impuesto de IVA a aplicarse a cada venta"
    }
    SCHEDULE_ROL          = {
      type                = "String"
      name                = "/${upper(local.service)}/SCHEDULE_ROL"
      value               = "${dependency.eventbridge_scheduler.outputs.iam_role_name}"
      description         = "Nombre del schedule rol del ${local.service}"
    }
    KINESIS_POLL_DELAY    = {
      type                = "String"
      name                = "/${upper(local.service)}/KINESIS_POLL_DELAY"
      value               = "250"
      description         = "kinesis poll delay"
    }
    KINESIS_LIMIT         = {
      type                = "String"
      name                = "/${upper(local.service)}/KINESIS_LIMIT"
      value               = "10000"
      description         = "Kinesis limit"
    }
    PAYMENTS_BUCKET_NAME  = {
      type                = "String"
      name                = "/${upper(local.service)}/BUCKET_NAME"
      value               = "payments-producer-${get_aws_account_id()}"
      description         = "name bucket payments"
    }
  }
}
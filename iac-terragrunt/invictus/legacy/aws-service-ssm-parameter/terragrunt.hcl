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

inputs = {
  ssm_parameters = {
    PRODUCER_BASE_URL = {
      type        = "String"
      name        = "/GLOBAL/PRODUCER_${upper(local.service)}_BASE_URL"
      value       = "http://${dependency.load_balancer.outputs.nlb_dns_name}:${dependency.ecs.outputs.listener_port}/"
      description = "Configuración de máscaras de los logs"
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
      value       = "${dependency.secret_manager.outputs.secret_name}"
      description = "Secreto de la base de datos de ${local.service}"
    }
    IDE_CARGO = {
      type        = "String"
      name        = "/${upper(local.service)}/IDE_CARGO"
      value       = "#{parameter_ide_cargo}#"
      description = "Código del cargo que tendrán los nuevos vendedores. Debe estar creado previamente en siga."
    }
    IDE_CATEGORY_VENDEDOR = {
      type        = "String"
      name        = "/${upper(local.service)}/IDE_CATEGORIA_VENDEDOR"
      value       = "#{parameter_ide_category_vendedor}#"
      description = "Código de la categoría en la que quedarán asignados los nuevos vendedores. Debe estar creado previamente en siga."
    }
    IDE_EMPRESA = {
      type        = "String"
      name        = "/${upper(local.service)}/IDE_EMPRESA"
      value       = "#{parameter_ide_empresa}#"
      description = "Código de la empresa en la que quedarán asignados los nuevos vendedores. Debe estar creado previamente en siga."
    }
    IDE_SITIOVENTA = {
      type        = "String"
      name        = "/${upper(local.service)}/IDE_SITIOVENTA"
      value       = "#{parameter_ide_sitioventa}#"
      description = "Código del sitio de venta donde quedarán registrados los equipos de los vendedores. A cada nuevo vendedor se le creará un nuevo equipo. Debe estar creado previamente en siga."
    }
    IDE_TECNOLOGIA = {
      type        = "String"
      name        = "/${upper(local.service)}/IDE_TECNOLOGIA"
      value       = "#{parameter_ide_tecnologia}#"
      description = "Código de la tecnología del nuevo equipo. Debe estar creado previamente en siga."
    }
    IDE_TIPO_PAGOS_SUBSIDIO = {
      type        = "String"
      name        = "/${upper(local.service)}/IDE_TIPO_PAGOS_SUBSIDIO"
      value       = "#{parameter_ide_tipo_pagos_subsidio}#"
      description = "Código de la tipo de pago por subsidio para el pago de betplay. debe ester previamente creado en siga para la replica y parámetro obligatorio."
    }
    ID_PRODUCTO_SIGA_MIPOS = {
      type        = "String"
      name        = "/${upper(local.service)}/ID_PRODUCTO_SIGA_MIPOS"
      value       = jsonencode(jsondecode(file("./parameters/#{parameter_id_producto_siga_mipos}#")))
      description = "Parametro con los id producto y id operacion de nexo y sus correspondientes siglas para siga."
    }
    KINESIS_POLL_DELAY = {
      type        = "String"
      name        = "/${upper(local.service)}/KINESIS_POLL_DELAY"
      value       = "250"
      description = "kinesis poll delay"
    }
    KINESIS_LIMIT = {
      type        = "String"
      name        = "/${upper(local.service)}/KINESIS_LIMIT"
      value       = "10000"
      description = "Kinesis limit"
    }
  }
}
locals {
  service             = "${basename(dirname(get_terragrunt_dir()))}"
}

include "root" {
  path                = find_in_parent_folders("root.hcl")
}

terraform {
  source              = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
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

inputs                = {
  ssm_parameters      = {
    PRODUCER_BASE_URL = {
      type            = "String"
      name            = "/GLOBAL/PRODUCER_${upper(replace(local.service, "-", "_"))}_BASE_URL"
      value           = "http://${dependency.load_balancer.outputs.nlb_dns_name}:${dependency.ecs.outputs.listener_port}/"
      description     = "Configuración de máscaras de los logs"
    }
    LOG_LEVEL         = {
      type            = "String"
      name            = "/${upper(local.service)}/LOGLEVEL"
      value           = "#{parameter_log_level}#"
      description     = "Nivel de log de ${local.service}"
    }
    CAPS_FILE_SIZE    = {
      type            = "String"
      name            = "/${upper(local.service)}/CAPS_FILE_SIZE"
      value           = "#{parameter_caps_file_size}#"
      description     = "Tamaño en MB para la carga de archivos de topes"
    }
    CONNECTION_LIMIT  = {
      type            = "String"
      name            = "/${upper(local.service)}/CONNECTION_LIMIT"
      value           = "200"
      description     = "connectionLimit"
    }
    QUEUE_LIMIT       = {
      type            = "String"
      name            = "/${upper(local.service)}/QUEUE_LIMIT"
      value           = "10"
      description     = "queueLimit"
    }
  }
}
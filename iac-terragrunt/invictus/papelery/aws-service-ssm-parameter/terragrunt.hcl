locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "ecs"            {
  config_path               = "../aws-service-ecs"
  mock_outputs              = {
    listener_port           = 0000
  }
}

dependency "load_balancer"  {
  config_path               = "../../initial-infrastructure/aws-service-load-balancer"
  mock_outputs              = {
    nlb_dns_name            = "mock-nlb-dns-name"
  }
}

dependency "secret_manager" {
  config_path               = "../aws-service-secret-manager"
  mock_outputs              = {
    secret_name             = "mock-secret-name"
  }
}

inputs                      = {
  ssm_parameters            = {
    PRODUCER_BASE_URL       = {
      type                  = "String"
      name                  = "/GLOBAL/PRODUCER_${upper(local.service)}_BASE_URL"
      value                 = "http://${dependency.load_balancer.outputs.nlb_dns_name}:${dependency.ecs.outputs.listener_port}/"
      description           = "Configuración de máscaras de los logs"
    }
    LOG_LEVEL               = {
      type                  = "String"
      name                  = "/${upper(local.service)}/LOGLEVEL"
      value                 = "#{parameter_log_level}#"
      description           = "Nivel de log de ${local.service}"
    },
    DB_SECRET               = {
      type                  = "String"
      name                  = "/${upper(local.service)}/DB_SECRET"
      value                 = "${dependency.secret_manager.outputs.secret_name}"
      description           = "Secreto de la base de datos de ${local.service}"
    },
    MAIN_COMPANY_ID         = {
      type                  = "String"
      name                  = "/${upper(local.service)}/MAIN_COMPANY_ID"
      value                 = "#{parameter_main_company_id}#"
      description           = "Id de la empresa principal"
    },
    PERCENTAGE_IVA          = {
      type                  = "String"
      name                  = "/${upper(local.service)}/PERCENTAGE_IVA"
      value                 = "19"
      description           = "Porcentaje de iva para modulo de papeleria"
    },
    PERCENTAGE_RETEIVA      = {
      type                  = "String"
      name                  = "/${upper(local.service)}/PERCENTAGE_RETEIVA"
      value                 = "1"
      description           = "reteiva para modulo de papeleria"
    },
    PERCENTAGE_RETEFUENTE   = {
      type                  = "String"
      name                  = "/${upper(local.service)}/PERCENTAGE_RETEFUENTE"
      value                 = "2"
      description           = "retefuente para modulo de papeleria"
    },
  }
}
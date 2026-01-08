locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "ecs"                   {
  config_path                      = "../aws-service-ecs"
  mock_outputs                     = {
    listener_port                  = 0000
  }
}

dependency "load_balancer"         {
  config_path                      = "../../initial-infrastructure/aws-service-load-balancer"
  mock_outputs                     = {
    nlb_dns_name                   = "mock-nlb-dns-name"
  }
}

dependency "secret_manager"        {
  config_path                      = "../aws-service-secret-manager"
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

inputs                             = {
  ssm_parameters                   = {
    PRODUCER_BASE_URL              = {
      type                         = "String"
      name                         = "/GLOBAL/PRODUCER_${upper(local.service)}_BASE_URL"
      value                        = "http://${dependency.load_balancer.outputs.nlb_dns_name}:${dependency.ecs.outputs.listener_port}/"
      description                  = "Configuración de máscaras de los logs"
    }
    LOG_LEVEL                      = {
      type                         = "String"
      name                         = "/${upper(local.service)}/LOGLEVEL"
      value                        = "#{parameter_log_level}#"
      description                  = "Nivel de log de ${local.service}"
    }
    DB_SECRET                      = {
      type                         = "String"
      name                         = "/${upper(local.service)}/DB_SECRET"
      value                        = "${dependency.secret_manager.outputs.secret_name}"
      description                  = "Secreto de la base de datos de ${local.service}"
    }
    SCHEDULE_ROL                   = {
      type                         = "String"
      name                         = "/${upper(local.service)}/SCHEDULE_ROL"
      value                        = "${dependency.eventbridge_scheduler.outputs.iam_role_name}"
      description                  = "Nombre del schedule rol del ${local.service}"
    }
    COLLECTED_BUCKET_NAME          = {
      type                         = "String"
      name                         = "/${upper(local.service)}/BUCKET_NAME"
      value                        = "collected-documents-${get_aws_account_id()}"
      description                  = "name bucket collected"
    }
  }
}
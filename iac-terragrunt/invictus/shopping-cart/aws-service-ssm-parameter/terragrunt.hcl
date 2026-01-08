locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "ecs"              {
  config_path                 = "../aws-service-ecs"
  mock_outputs                = {
    listener_port             = 0000
  }
}

dependency "load_balancer"    {
  config_path                 = "../../initial-infrastructure/aws-service-load-balancer"
  mock_outputs                = {
    nlb_dns_name              = "mock-nlb-dns-name"
  }
}

dependency "secret_manager"   {
  config_path                 = "../aws-service-secret-manager"
  mock_outputs                = {
    secret_name               = "mock-secret-name"
  }
}

inputs                        = {
  ssm_parameters              = {
    PRODUCER_BASE_URL         = {
      type                    = "String"
      name                    = "/GLOBAL/PRODUCER_${upper(replace(local.service, "-", "_"))}_BASE_URL"
      value                   = "http://${dependency.load_balancer.outputs.nlb_dns_name}:${dependency.ecs.outputs.listener_port}/"
      description             = "Configuración de máscaras de los logs"
    }
    LOG_LEVEL                 = {
      type                    = "String"
      name                    = "/${upper(replace(local.service, "-", "_"))}/LOGLEVEL"
      value                   = "#{parameter_log_level}#"
      description             = "Nivel de log de ${local.service}"
    }
    DB_SECRET                 = {
      type                    = "String"
      name                    = "/${upper(replace(local.service, "-", "_"))}/DB_SECRET"
      value                   = "${dependency.secret_manager.outputs.secret_name}"
      description             = "Secreto de la base de datos de ${local.service}"
    }
    CONNECTION_LIMIT          = {
      type                    = "String"
      name                    = "/${upper(replace(local.service, "-", "_"))}/CONNECTION_LIMIT"
      value                   = "200"
      description             = "connectionLimit"
    }
    QUEUE_LIMIT               = {
      type                    = "String"
      name                    = "/${upper(replace(local.service, "-", "_"))}/QUEUE_LIMIT"
      value                   = "10"
      description             = "queueLimit"
    }
    SHOPPING_CART_BUCKET_NAME = {
      type                    = "String"
      name                    = "/${upper(local.service)}/BUCKET_NAME"
      value                   = "shopping-cart-${get_aws_account_id()}"
      description             = "name bucket shopping-cart"
    }
  }
}
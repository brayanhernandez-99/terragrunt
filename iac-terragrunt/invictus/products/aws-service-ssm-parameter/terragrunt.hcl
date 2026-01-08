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

dependency "s3"             {
  config_path               = "../aws-service-s3"
  mock_outputs              = {
    s3_bucket_name          = "mock-s3-bucket-name"
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
    }
    DB_SECRET               = {
      type                  = "String"
      name                  = "/${upper(local.service)}/DB_SECRET"
      value                 = "${dependency.secret_manager.outputs.secret_name}"
      description           = "Secreto de la base de datos de ${local.service}"
    }
    BUCKET_NAME             = {
      type                  = "String"
      name                  = "/${upper(local.service)}/BUCKET_NAME"
      value                 = "${dependency.s3.outputs.s3_bucket_name}"
      description           = "Bucket name de ${local.service}"
    }
    LIMIT_NUMBER_ITEMS      = {
      type                  = "String"
      name                  = "/SHOPPING_CART/LIMIT_NUMBER_ITEMS"
      value                 = "#{parameter_limit_number_items}#"
      description           = "Parámetro de items en el carrito"
    }
    KINESIS_POLL_DELAY      = {
      type                  = "String"
      name                  = "/${upper(local.service)}/KINESIS_POLL_DELAY"
      value                 = "250"
      description           = "kinesis poll delay"
    }
    KINESIS_LIMIT           = {
      type                  = "String"
      name                  = "/${upper(local.service)}/KINESIS_LIMIT"
      value                 = "10000"
      description           = "Kinesis limit"
    }
    PRODUCTS_CHANCES        = {
      type                  = "String"
      name                  = "/${upper(local.service)}/CHANCES"
      value                 = "#{parameter_products_chance}#"
      description           = "ID de la categoría de juegos de suerte y azar"
    }
  }
}
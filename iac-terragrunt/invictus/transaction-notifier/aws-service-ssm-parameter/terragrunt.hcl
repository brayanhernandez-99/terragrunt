include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = basename(dirname(get_terragrunt_dir()))
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}


dependency "ecs" {
  config_path = "../aws-service-ecs"
  mock_outputs = {
    listener_port = 8080
  }
}

dependency "cloudmap" {
  config_path = "../../initial-infrastructure/aws-service-cloudmap"
  mock_outputs = {
    cloudmap_namespace_name = "mock-namespace.local"
  }
}

dependency "load_balancer" {
  config_path = "../../initial-infrastructure/aws-service-load-balancer"
  mock_outputs = {
    nlb_dns_name = "mock-nlb-123456.elb.us-east-1.amazonaws.com"
  }
}

inputs = {
  ssm_parameters = {
    PRODUCER_BASE_URL = {
      type        = "String"
      name        = "/GLOBAL/PRODUCER_${upper(replace(local.service, "-", "_"))}_BASE_URL"
      value       = "http://${local.service}.${dependency.cloudmap.outputs.cloudmap_namespace_name}:8080/"
      description = "Endpoint base del servicio expuesto a través de Cloudmap"
    }
    LOG_LEVEL = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/LOGLEVEL"
      value       = "#{parameter_log_level}#"
      description = "Nivel de log de ${local.service}"
    }
    CONNECTION_LIMIT = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/CONNECTION_LIMIT"
      value       = "200"
      description = "connectionLimit"
    }
    QUEUE_LIMIT = {
      type        = "String"
      name        = "/${upper(replace(local.service, "-", "_"))}/QUEUE_LIMIT"
      value       = "10"
      description = "queueLimit"
    }
  }
}
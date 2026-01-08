include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ssm-parameter"
}

dependency "cognito"    {
  config_path           = "../../initial-infrastructure/aws-service-cognito"
  mock_outputs          = {
    user_pool_id        = "mock_user_pool_id"
  }
}

inputs = {
  ssm_parameters        = {
    KEY_URL             = {
      type              = "String"
      name              = "/BFF_SELLERS/KEY_URL"
      value             = "https://cognito-idp.us-east-1.amazonaws.com/${dependency.cognito.outputs.user_pool_id}/.well-known/jwks.json"
      description       = "URL de la llave pública de Cognito"
    }
    LOG_LEVEL           = {
      type              = "String"
      name              = "/BFF_SELLERS/LOGLEVEL"
      value             = "#{parameter_log_level}#"
      description       = "Nivel de log de BFF_SELLERS"
    }
    SELLERS_PUBLIC_URL  = {
      type              = "String"
      name              = "/GLOBAL/SELLERS_PUBLIC_URL"
      value             = "#{parameter_sellers_public_url}#"
      description       = "Url para acceder a los servicios expuestos por el bff"
    }
    SELLERS_API_URL     = {
      type              = "String"
      name              = "/GLOBAL/SELLERS_API_URL"
      value             = "#{parameter_sellers_api_url}#"
      description       = "Url para acceder a los servicios expuestos por el bff"
    }
  }
}
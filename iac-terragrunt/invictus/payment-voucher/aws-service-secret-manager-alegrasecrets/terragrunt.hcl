include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs = {
  secret_name        = "alegrasecrets"
  secret_description = "Credenciales alegra para consumir el servicio"
  secret_string_value = {
    authorization       = "#{secret_alegrasecrets_authorization}#"
    baseUrl             = "#{secret_alegrasecrets_baseUrl}#"
    endpointEmpresas    = "#{secret_alegrasecrets_endpointEmpresas}#"
    endpointFacturas    = "#{secret_alegrasecrets_endpointFacturas}#"
    endpointResolutions = "#{secret_alegrasecrets_endpointResolutions}#"
    endpointSendEmail   = "#{secret_alegrasecrets_endpointSendEmail}#"
    replyTo             = "#{secret_alegrasecrets_replyTo}#"
  }
}
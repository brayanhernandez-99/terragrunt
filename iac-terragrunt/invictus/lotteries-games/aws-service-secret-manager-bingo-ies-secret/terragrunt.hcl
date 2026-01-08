include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs                      = {
  secret_name               = "bingo-ies-secret"
  secret_description        = "Secreto de conexión a Bingo"
  secret_string_value       = {
    urlBase                 = "#{secret_bingo-ies-secret_urlBase}#"
    authUser                = "#{secret_bingo-ies-secret_authUser}#"
    authPassword            = "#{secret_bingo-ies-secret_authPassword}#"
    authenticationUser      = "#{secret_bingo-ies-secret_authenticationUser}#"
    authenticationPassword  = "#{secret_bingo-ies-secret_authenticationPassword}#"
    serviceTimeout          = "#{secret_bingo-ies-secret_serviceTimeout}#"
    urlAuthentication       = "#{secret_bingo-ies-secret_urlAuthentication}#"
    urlRooms                = "#{secret_bingo-ies-secret_urlRooms}#"
    urlRaffles              = "#{secret_bingo-ies-secret_urlRaffles}#"
    urlBet                  = "#{secret_bingo-ies-secret_urlBet}#"
    maxCantidadTablas       = "#{secret_bingo-ies-secret_maxCantidadTablas}#"
    urlRollaback            = "#{secret_bingo-ies-secret_urlRollaback}#"
  }
}
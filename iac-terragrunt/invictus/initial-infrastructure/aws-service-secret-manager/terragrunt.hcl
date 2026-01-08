include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs = {
  secret_name                                 = "mipossecret"
  secret_description                          = "Secreto de mipos"
  secret_string_value                         = {
  urlResponse                                 = "#{secret_mipossecret_urlResponse}#"
  aplicacionOrigen                            = "#{secret_mipossecret_aplicacionOrigen}#"
  userName                                    = "#{secret_mipossecret_userName}#"
  password                                    = "#{secret_mipossecret_password}#"
  secretKeyText                               = "#{secret_mipossecret_secretKeyText}#"
  urlResponseBff                              = "#{secret_mipossecret_urlResponseBff}#"
  salt                                        = "#{secret_mipossecret_salt}#"
  sUser                                       = "#{secret_mipossecret_sUser}#"
  sPwd                                        = "#{secret_mipossecret_sPwd}#"
  idRed                                       = "#{secret_mipossecret_idRed}#"
  idEstablishmentOrigin                       = "#{secret_mipossecret_idEstablishmentOrigin}#"
  idProductRedWiretransfer                    = 329
  idProductRedWiretransferNexo                = 8
  idProductRedShipments                       = 67
  idProductRedCorrespondentDepositNoTarjet    = 10004
  idProductRedInternationalWiretransfer       = 395647
  urlResponseReverse                          = "#{secret_mipossecret_urlResponseReverse}#"
  idProductRedCorrespondentWithdrawalNoTarjet = 10006
  idProductRedCorrespondentPayTarjetNoTarjet  = 10032
  idProductRedCorrespondentPayWalletNoTarjet  = 10011
  idProductRedWiretransferCancel              = 330
  idProductRedDepositNoTarjetBBVA             = 10113
  mockMipos                                   = "#{secret_mipossecret_mockMipos}#"
  urlMockMipos                                = "#{secret_mipossecret_urlMockMipos}#"
  idProductRedCollectBancoAgrario             = 10003
  }
}

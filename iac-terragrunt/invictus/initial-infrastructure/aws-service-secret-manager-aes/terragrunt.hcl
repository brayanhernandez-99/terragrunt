include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs = {
  secret_name           = "keySecretAes"
  secret_description    = "Secreto de encriptación AES"
  secret_string_value   = {
    key                 = "#{secret_keySecretAes_key}#"
    salt                = "#{secret_keySecretAes_salt}#"
    hashingSecret       = "#{secret_keySecretAes_hashingSecret}#"
  }
}

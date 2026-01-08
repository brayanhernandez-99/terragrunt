include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs = {
  secret_name           = "fundssecret"
  secret_description    = "Secreto de fondos"
  secret_string_value   = {
    hashingSecret       = "#{secret_fundssecret_hashingSecret}#"
    salt                = "#{secret_fundssecret_salt}#"
  }
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = basename(dirname(get_terragrunt_dir()))
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

inputs = {
  secret_name        = "labsmobile-otp-secret"
  secret_description = "Secreto en labsmobile para envio de mensajes OTP"
  secret_string_value = {
    username = "#{secret_labsmobile-otp-secret_username}#"
    token    = "#{secret_labsmobile-otp-secret_token}#"
  }
}
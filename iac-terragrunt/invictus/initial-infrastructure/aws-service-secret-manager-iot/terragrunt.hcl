include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-secret-manager"
}

dependency "iam" {
  config_path = "../../initial-infrastructure/aws-service-iam-role/user-iot"
  mock_outputs = {
    access_key_id     = "AKIAIOSFODNN7EXAMPLE"
    secret_access_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  }
}

inputs = {
  secret_name        = "iot-connect-secret"
  secret_description = "Ak SK cuenta IOT"
  secret_string_value = {
    accessKey       = dependency.iam.outputs.access_key_id
    secretAccessKey = dependency.iam.outputs.secret_access_key
  }
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-iam-user"
}

inputs = {
  name          = "iot-connect"
  policy_arns   = "arn:aws:iam::aws:policy/AWSIoTDataAccess"
}
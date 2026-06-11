include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-iot-policies"
}

inputs = {
  region               = "#{aws_region}#"
  name_policy_syn      = "policy-sync"
  name_policy_notifier = "policy-notifier"
  aws_account_id       = "${get_aws_account_id()}"
}

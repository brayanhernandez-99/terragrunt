include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-kms"
}

inputs = {
  aws_account_id = "${get_aws_account_id()}"
  name           = "alias/km-kinesis"
}

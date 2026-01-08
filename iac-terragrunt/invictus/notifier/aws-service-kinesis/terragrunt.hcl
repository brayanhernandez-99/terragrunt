include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-kinesis"
}

inputs             = {
  stream_name      = "${title(local.service)}"
  shard_count      = 1
  retention_period = 48
}

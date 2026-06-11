include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = basename(dirname(get_terragrunt_dir()))
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-systems-manager"
}

inputs = {
  aws_region                              = "#{aws_region}#"
  aws_account_id                          = "${get_aws_account_id()}"
  parameter_store_high_throughput_enabled = "true"
  parameter_default_tier                  = "Standard"
}

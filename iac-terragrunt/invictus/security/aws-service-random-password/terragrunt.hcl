include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = basename(dirname(get_terragrunt_dir()))
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-random-password"
}

inputs = {
  length  = 24
  numeric = true
  upper   = true
  lower   = true
}

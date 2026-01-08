include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-s3"
}

inputs = {
  bucket_name = "mf-recharges-${get_aws_account_id()}"
}

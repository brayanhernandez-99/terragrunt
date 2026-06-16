include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-s3"
}

inputs = {
  bucket_name                         = "lotteries-games-documents-${get_aws_account_id()}"
  enable_put_object_encryption_policy = true
  enable_object_ownership_controls    = true
  object_ownership_type               = "ObjectWriter"
}
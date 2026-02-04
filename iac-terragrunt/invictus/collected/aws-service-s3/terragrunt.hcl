include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-s3"
}

inputs = {
  bucket_name                         = "collected-documents-${get_aws_account_id()}"
  enable_object_ownership_controls    = true
  enable_put_object_encryption_policy = false
  object_ownership_type               = "BucketOwnerEnforced"
}
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-s3"
}

inputs = {
  bucket_name                      = "products-${get_aws_account_id()}"
  enable_object_ownership_controls = true
  object_ownership_type            = "ObjectWriter"
  enable_public_access_block       = true
  val_public_access_block          = false # Deja el s3 publico
}

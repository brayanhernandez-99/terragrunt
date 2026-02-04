include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-s3"
}

inputs = {
  bucket_name                            = "recharges-documents-${get_aws_account_id()}"
  enable_object_ownership_controls       = true
  enable_put_object_encryption_policy_ip = true
  object_ownership_type                  = "ObjectWriter"
  allowed_ips = [
    "34.236.228.61",
    "52.205.6.240",
    "54.157.106.105"
  ]
}
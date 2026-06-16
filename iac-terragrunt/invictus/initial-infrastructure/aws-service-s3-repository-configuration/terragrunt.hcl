include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  # source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-s3-apps"
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-s3"
}

# dependency "kms" {
#   config_path = "../aws-service-kinesis-cmk"
#   mock_outputs = {
#     kms_key_arn = "mock_kms_key_arn"
#   }
# }

inputs = {
  bucket_name = "configuration-${get_aws_account_id()}"
  # kms_key_arn = dependency.kms.outputs.kms_key_arn
}

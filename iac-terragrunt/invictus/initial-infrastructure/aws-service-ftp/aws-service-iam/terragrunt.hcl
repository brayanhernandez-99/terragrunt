include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-iam-ftp"
}

dependency "s3" {
  config_path = "../aws-service-s3"
  mock_outputs = {
    s3_bucket_arn = "mock_s3_bucket_arn"
  }
}

inputs = {
  iam_role_name = "ftp-ec2-s3-role"
  s3_bucket_arn = dependency.s3.outputs.s3_bucket_arn
}
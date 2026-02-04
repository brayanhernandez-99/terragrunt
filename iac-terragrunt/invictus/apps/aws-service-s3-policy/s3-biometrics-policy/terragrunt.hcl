include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-s3-policy"
}

dependency "s3" {
  config_path = "../../aws-service-s3/s3-biometrics"
  mock_outputs = {
    s3_bucket_id   = "mock_s3_bucket_id"
    s3_bucket_name = "mock_s3_bucket_name"
  }
}

dependency "cloudfront" {
  config_path = "../../aws-service-cloudfront/cloudfront-biometrics"
  mock_outputs = {
    cloudfront_arn = "mock_cloudfront_arn"
  }
}

inputs = {
  s3_bucket_id                = dependency.s3.outputs.s3_bucket_id
  bucket_resource_arn         = dependency.s3.outputs.s3_bucket_id
  cloudfront_distribution_arn = dependency.cloudfront.outputs.cloudfront_arn
  s3_bucket_name              = dependency.s3.outputs.s3_bucket_name
}

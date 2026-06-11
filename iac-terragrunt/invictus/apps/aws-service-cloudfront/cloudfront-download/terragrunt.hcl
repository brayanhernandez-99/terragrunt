include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-cloudfront"
}

dependency "s3" {
  config_path = "../../aws-service-s3/s3-download"
  mock_outputs = {
    s3_bucket_id          = "mock_s3_bucket_id"
    s3_bucket_domain_name = "mock_s3_bucket_domain_name"
  }
}

inputs = {
  origin_id              = dependency.s3.outputs.s3_bucket_id
  origin_domain_name     = dependency.s3.outputs.s3_bucket_domain_name
  alternate_domain_names = ["#{aws_cloudfront_alternate_domain_download}#"]
  price_class            = "PriceClass_All"
  comment                = "Distribución de CloudFront"
  acm_certificate_arn    = "#{aws_arn_certificate}#"
  aws_cloudfront_tags = {
    Name    = "download",
    Project = "cloudfront-download"
  }
  viewer_protocol_policy = "redirect-to-https"
  cookies_forward        = "none"
  query_string           = false
  compress               = true
  allowed_methods        = ["GET", "HEAD"]
  cached_methods         = ["GET", "HEAD"]
}

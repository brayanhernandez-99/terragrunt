include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-cloudfront"
}

dependency "s3" {
  config_path = "../../../initial-infrastructure/aws-service-s3-repository-configuration"
  mock_outputs = {
    s3_bucket_id          = "s3-bucket-id"
    s3_bucket_domain_name = "s3-bucket.s3.amazonaws.com"
  }
}

inputs = {
  origin_id              = dependency.s3.outputs.s3_bucket_id
  origin_domain_name     = dependency.s3.outputs.s3_bucket_domain_name
  origin_path            = "/assets"
  alternate_domain_names = ["#{aws_cloudfront_alternate_domain_assets}#"]
  price_class            = "PriceClass_All"
  comment                = "Distribución de CloudFront"
  acm_certificate_arn    = "#{aws_arn_certificate}#"
  aws_cloudfront_tags = {
    Name    = "assets",
    Project = "cloudfront-assets"
  }
  viewer_protocol_policy = "redirect-to-https"
  cookies_forward        = "none"
  query_string           = false
  compress               = true
  allowed_methods        = ["GET", "HEAD"]
  cached_methods         = ["GET", "HEAD"]
}

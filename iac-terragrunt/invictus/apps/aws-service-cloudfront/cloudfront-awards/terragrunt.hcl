include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-cloudfront"
}

dependency "s3" {
  config_path = "../../aws-service-s3/s3-awards"
  mock_outputs = {
    s3_bucket_id          = "s3-bucket-id"
    s3_bucket_domain_name = "s3-bucket.s3.amazonaws.com"
  }
}

dependency "cache_policy" {
  config_path = "../../aws-service-custom-cache-policy"
  mock_outputs = {
    custom_cache_policy_id = "cache-policy-id"
  }
}

dependency "cloudfront-function" {
  config_path = "../../aws-service-cloudfront-function/cloudfront-function-header"
  mock_outputs = {
    function_arn = "arn:aws:cloudfront::123456789012:function/function"
  }
}

inputs = {
  origin_id              = dependency.s3.outputs.s3_bucket_id
  origin_domain_name     = dependency.s3.outputs.s3_bucket_domain_name
  custom_cache_policy_id = dependency.cache_policy.outputs.custom_cache_policy_id
  alternate_domain_names = ["#{aws_cloudfront_alternate_domain_awards}#"]
  price_class            = "PriceClass_All"
  comment                = "Distribución de CloudFront"
  acm_certificate_arn    = "#{aws_arn_certificate}#"
  aws_cloudfront_tags = {
    Name    = "awards",
    Project = "cloudfront-awards"
  }
  viewer_protocol_policy = "redirect-to-https"
  default_root_object    = "index.html"
  cookies_forward        = "none"
  query_string           = false
  compress               = true
  allowed_methods        = ["GET", "HEAD"]
  cached_methods         = ["GET", "HEAD"]

  custom_error_pages = {
    "404" = {
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 3000
    }
    "500" = {
      error_code            = 400
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 3000
    }
  }

  function_associations = {
    "viewer-response-function" = {
      event_type   = "viewer-response"
      function_arn = dependency.cloudfront-function.outputs.function_arn
    }
  }
}

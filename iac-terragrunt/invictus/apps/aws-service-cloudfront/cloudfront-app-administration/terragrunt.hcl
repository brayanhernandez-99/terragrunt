include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-cloudfront"
}

dependency "s3"                   {
  config_path                     = "../../aws-service-s3/s3-app-administration"
  mock_outputs                    = {
    s3_bucket_id                  = "mock_s3_bucket_id"
    s3_bucket_domain_name         = "mock_s3_bucket_domain_name"
  }
}

dependency "cache_policy"         {
  config_path                     = "../../aws-service-custom-cache-policy"
  mock_outputs                    = {
    custom_cache_policy_id        = "mock_cache_policy_id"
  }
}

dependency "cloudfront-function" {
  config_path                    = "../../aws-service-cloudfront-function/cloudfront-function-header"
  mock_outputs                   = {
    function_arn                 = "mock_function_arn"
  }
}

inputs = {
  origin_id                      = dependency.s3.outputs.s3_bucket_id
  origin_domain_name             = dependency.s3.outputs.s3_bucket_domain_name
  custom_cache_policy_id         = dependency.cache_policy.outputs.custom_cache_policy_id
  alternate_domain_names         = ["#{aws_cloudfront_alternate_domain_admin}#"]
  price_class                    = "PriceClass_All"
  comment                        = "Distribución de CloudFront"
  acm_certificate_arn            = "#{aws_arn_certificate}#"
  aws_cloudfront_tags            = {
    Name                         = "app-administration",
    Project                      = "microFrontend-app-administration"
  }
  viewer_protocol_policy         = "redirect-to-https"
  cookies_forward                = "none"
  query_string                   = false
  allowed_methods                = ["GET", "HEAD", "OPTIONS"]
  cached_methods                 = ["GET", "HEAD"]

  custom_error_pages = {
    "404" = {
      error_code                 = 403
      response_code              = 200
      response_page_path         = "/index.html"
      error_caching_min_ttl      = 3000
   }
    "500" = {
      error_code                 = 400
      response_code              = 200
      response_page_path         = "/index.html"
      error_caching_min_ttl      = 3000
    }
  }

  function_associations = {
    "viewer-response-function"   = {
      event_type                 = "viewer-response"
      function_arn               = dependency.cloudfront-function.outputs.function_arn
    }
  }
}

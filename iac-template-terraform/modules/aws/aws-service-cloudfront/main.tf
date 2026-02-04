resource "aws_cloudfront_distribution" "create_cloudfront" {
  origin {
    domain_name              = var.origin_domain_name
    origin_id                = "Origin-${var.origin_id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  lifecycle {
    ignore_changes = [
      origin
    ]
  }

  aliases = var.alternate_domain_names
  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn # ARN del certificado existente en ACM
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.comment
  default_root_object = var.default_root_object

  default_cache_behavior {
    target_origin_id       = "Origin-${var.origin_id}"
    compress               = var.compress
    viewer_protocol_policy = var.viewer_protocol_policy
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    cache_policy_id        = var.custom_cache_policy_id

    dynamic "function_association" {
      for_each = var.function_associations
      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_pages
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_type != "none" ? var.geo_restriction_countries : null
    }
  }
  tags = var.aws_cloudfront_tags
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "OAC-${var.origin_id}"
  description                       = "Origin Access Control for ${var.origin_domain_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = var.oac_signing_behavior
  signing_protocol                  = var.oac_signing_protocol
}

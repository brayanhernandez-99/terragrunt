include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-cloudfront-function"
}

inputs = {
  name_function    = "mf-invictus-add-header-function"
  runtime_function = "cloudfront-js-2.0"
  code_function    = <<EOT
function handler(event) {
  var response = event.response;
  var headers = response.headers;
  var request = event.request;

  headers['strict-transport-security'] = { value: 'max-age=63072000; includeSubdomains; preload' };
  headers['access-control-allow-origin'] = { value: 'https://#{aws_cloudfront_function_origin}#' };
  headers['x-content-type-options'] = { value: 'nosniff' };
  headers['x-frame-options'] = { value: 'DENY' };
  headers['referrer-policy'] = { value: 'no-referrer' };
  headers['x-xss-protection'] = { value: '1; mode=block' };
  headers['permissions-policy'] = { value: 'unload=()' };
  headers['content-security-policy'] = {
    value:
      "default-src 'self' https://*.#{aws_domain_certificate}#; " +
      "script-src 'self' 'unsafe-eval'; " +
      "script-src-elem 'self' https://*.#{aws_domain_certificate}# 'sha256-fmfWCGuIurfYWhouMXpzq9ZvAABoKR4N3LGOkDIpq1E='; " +
      "style-src 'self' 'unsafe-inline'; " +
      "style-src-elem 'self' https://*.#{aws_domain_certificate}#; " +
      "font-src 'self' data:; " +
      "img-src 'self' data: https://*.amazonaws.com; " +
      "frame-src 'self' https://*.#{aws_domain_certificate}# https://uxtechnology.atlassian.net; " +
      "connect-src 'self' https://*.amazonaws.com https://*.#{aws_domain_certificate}#"
  };

  delete headers['x-amz-server-side-encryption'];
  delete headers['x-amz-cf-id'];
  delete headers['x-amz-cf-pop'];
  
  if (response.statusCode >= 200 && response.statusCode < 400) {
    if (request.uri === '/index.html' || request.uri === '/') {
      headers['cache-control'] = {
        value: 'public, max-age=60, must-revalidate'
      };
    } else {
      headers['cache-control'] = {
        value: 'public, max-age=31536000, immutable'
      };
    }
  }
  return response;
}
EOT
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-cloudfront-function"
}

inputs = {
  name_function    = "mf-add-header-function"
  runtime_function = "cloudfront-js-2.0"
  code_function    = <<EOT
function handler(event) {
    var request = event.request;
    var response = event.response;
    var headers = response.headers;
    var uri = request.uri;

    if (uri === '/assets/remoteEntry.js') {
        headers['cache-control'] = {
            value: 'public, max-age=0, must-revalidate'
        };
        headers['pragma'] = { value: 'no-cache' };
        headers['expires'] = { value: '0' };
    } else {
        headers['cache-control'] = {
            value: 'public, max-age=31536000, immutable'
        };
    }

    headers['strict-transport-security'] = {value: 'max-age=63072000; includeSubDomains; preload'};
    headers['access-control-allow-origin'] = { value: 'https://#{aws_cloudfront_function_origin}#' };
    headers['x-content-type-options'] = { value: 'nosniff' };
    headers['x-frame-options'] = { value: 'DENY' };
    headers['referrer-policy'] = { value: 'no-referrer' };
    headers['x-xss-protection'] = { value: '1; mode=block' };
    headers['permissions-policy'] = { value: 'unload=()' };
    return response;
}
EOT
}

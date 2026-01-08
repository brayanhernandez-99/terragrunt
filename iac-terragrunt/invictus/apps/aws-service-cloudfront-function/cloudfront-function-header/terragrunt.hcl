include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-cloudfront-function"
}

inputs = {
  name_function     = "mf-add-header-function"
  runtime_function  = "cloudfront-js-2.0"
  code_function     = <<EOT
function handler(event) {
    var headers = event.response.headers;
    headers['strict-transport-security'] = { value: 'max-age=63072000; includeSubdomains; preload' };
    headers['access-control-allow-methods'] = { value: 'GET, HEAD' };
    headers['access-control-allow-origin'] = { value: '*' };
    headers['x-content-type-options'] = { value: 'nosniff' };
    headers['x-frame-options'] = { value: 'DENY' };
    headers['referrer-policy'] = { value: 'no-referrer' };
    headers['x-xss-protection'] = { value: '1; mode=block' };
    headers['permissions-policy'] = { value: 'unload=()'};
    return event.response;
}
EOT
}

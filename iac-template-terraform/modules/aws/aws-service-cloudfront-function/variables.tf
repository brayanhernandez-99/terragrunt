variable "name_function" {
  description = "Nombre del bucket S3 para asociar la política."
  type        = string
}

variable "runtime_function" {
  description = "ARN del bucket S3 que se usará como recurso en la política."
  type        = string
}

variable "code_function" {
  description = "ARN de la distribución de CloudFront para restringir el acceso."
  type        = string
  default     = <<EOT
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


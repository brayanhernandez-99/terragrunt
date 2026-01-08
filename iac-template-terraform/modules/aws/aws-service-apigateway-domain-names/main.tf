resource "aws_api_gateway_domain_name" "custom_domain" {
  domain_name              = var.Domain_name
  regional_certificate_arn = var.arn_certificate

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "mapping" {
  api_id      = var.api_id  
  stage_name  = var.stage_name 
  domain_name = aws_api_gateway_domain_name.custom_domain.domain_name
}

output "api_endpoint" {
  description = "URL del endpoint de la API Gateway"
  value       = aws_api_gateway_rest_api.administration_api.execution_arn
}

output "api_id" {
  description = "id de la ip"
  value       = aws_api_gateway_rest_api.administration_api.id
}


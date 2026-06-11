output "api_endpoint" {
  description = "URL del endpoint de la API Gateway"
  value       = aws_api_gateway_rest_api.api_gateway.execution_arn
}

output "api_id" {
  description = "id de la ip"
  value       = aws_api_gateway_rest_api.api_gateway.id
}

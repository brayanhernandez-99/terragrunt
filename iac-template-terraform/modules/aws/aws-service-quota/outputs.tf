output "quota_arn" {
  description = "ARN de la cuota de AWS configurada"
  value       = aws_servicequotas_service_quota.quota.quota_arn
}

output "service_code" {
  description = "Código del servicio de AWS"
  value       = aws_servicequotas_service_quota.quota.service_code
}

output "quota_code" {
  description = "Código de la cuota de AWS"
  value       = aws_servicequotas_service_quota.quota.quota_code
}

output "quota_value" {
  description = "Valor configurado para la cuota de AWS"
  value       = aws_servicequotas_service_quota.quota.value
}

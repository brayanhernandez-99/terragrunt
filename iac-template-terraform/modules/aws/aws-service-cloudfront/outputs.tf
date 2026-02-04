output "cloudfront_distribution_id" {
  description = "ID de la distribución de CloudFront"
  value       = aws_cloudfront_distribution.create_cloudfront.id
}

output "cloudfront_domain_name" {
  description = "Nombre de dominio de la distribución de CloudFront"
  value       = aws_cloudfront_distribution.create_cloudfront.domain_name
}

output "cloudfront_oac_id" {
  description = "ID de Control de Acceso de Origen (OAC)"
  value       = aws_cloudfront_origin_access_control.oac.id
}

output "cloudfront_arn" {
  description = "ARN de la distribución de CloudFront"
  value       = aws_cloudfront_distribution.create_cloudfront.arn
}

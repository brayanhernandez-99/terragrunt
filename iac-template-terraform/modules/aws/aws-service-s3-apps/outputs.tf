output "s3_bucket_id" {
  description = "El ID del bucket S3"
  value       = aws_s3_bucket.my_bucket.id
}

output "s3_bucket_domain_name" {
  description = "Dominio completo del bucket de S3"
  value       = aws_s3_bucket.my_bucket.bucket_regional_domain_name
}

output "s3_bucket_arn" {
  description = "El ARN del bucket S3"
  value       = aws_s3_bucket.my_bucket.arn
}

output "s3_bucket_name" {
  description = "El nombre del bucket S3"
  value       = var.bucket_name
}

output "s3_bucket_id" {
  description = "ID del bucket S3"
  value       = aws_s3_bucket_policy.policy.bucket
}

output "s3_bucket_arn" {
  description = "ARN del bucket S3"
  value       = var.s3_bucket_arn
}

output "s3_bucket_policy_id" {
  description = "ID de la policy del bucket S3"
  value       = aws_s3_bucket_policy.policy.id
}

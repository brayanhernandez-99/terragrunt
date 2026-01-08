output "custom_cache_policy_id" {
  description = "ID de la custom cache policy"
  value       = aws_cloudfront_cache_policy.custom_cache_policy.id
}

output "user_pool_id" {
  description = "ID del User Pool de Cognito"
  value       = aws_cognito_user_pool.user_pool.id
}

output "user_pool_arn" {
  description = "ARN del User Pool de Cognito"
  value       = aws_cognito_user_pool.user_pool.arn
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.userpool_client.id
}
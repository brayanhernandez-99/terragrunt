output "secret_id" {
  value       = aws_secretsmanager_secret.secret_customer.id
  description = "Id of the secret"
}

output "secret_arn" {
  value = aws_secretsmanager_secret.secret_customer.arn
  description = "The ARN of the secret"
}

output "secret_name" {
  value = aws_secretsmanager_secret.secret_customer.name
  description = "Secret name"
}

output "secret_version_id"{
  value = aws_secretsmanager_secret_version.secret_customer_version.version_id
  description = "Current version of the secret"
}

output "secret_version_stages" {
  value = aws_secretsmanager_secret_version.secret_customer_version.version_stages
  description = "The associated stages for the current version of the secret"
}

output "secret_tags" {
  value = aws_secretsmanager_secret.secret_customer.tags
  description = "A mapping of resource tags objects associated with the secret"
}

output "ksm_key_id" {
  value = aws_secretsmanager_secret.secret_customer.kms_key_id
  description = "A mapping of resource tags objects associated with the secret"
}

output "secret_string_value"{
  sensitive = true
  value = aws_secretsmanager_secret_version.secret_customer_version.secret_string
  description = "A mapping of secret string"
}
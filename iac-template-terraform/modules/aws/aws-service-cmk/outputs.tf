output "kms_key_arn" {
  description = "ARN de la clave KMS creada para encriptar"
  value       = aws_kms_key.cmk.arn
}

output "kms_key_id" {
  value = aws_kms_key.cmk.key_id
}

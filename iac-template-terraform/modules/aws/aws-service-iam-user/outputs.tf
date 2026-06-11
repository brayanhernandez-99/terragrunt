output "access_key_id" {
  value     = aws_iam_access_key.user_key.id
  sensitive = true
}

output "secret_access_key" {
  value     = aws_iam_access_key.user_key.secret
  sensitive = true
}
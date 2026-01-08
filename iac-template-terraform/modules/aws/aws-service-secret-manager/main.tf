resource "aws_secretsmanager_secret" "secret_customer" {
  name        = var.secret_name
  description = var.secret_description
  tags        = var.secret_tags
  kms_key_id  = var.kms_key_id
}

resource "aws_secretsmanager_secret_version" "secret_customer_version" {
  secret_id     = aws_secretsmanager_secret.secret_customer.id
  secret_string = jsonencode(var.secret_string_value)
}

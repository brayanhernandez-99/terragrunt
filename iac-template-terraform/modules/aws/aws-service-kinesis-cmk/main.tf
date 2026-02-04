resource "aws_kms_key" "cmk" {
  description             = "Clave KMS administrada por el cliente"
  deletion_window_in_days = 10
  enable_key_rotation     = false

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableRootAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.aws_account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "cmk_alias" {
  name          = var.name_ckm
  target_key_id = aws_kms_key.cmk.id
}
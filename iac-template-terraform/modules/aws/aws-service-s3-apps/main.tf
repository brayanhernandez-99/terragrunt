resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  tags   = var.bucket_tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn # El ID o ARN de tu clave KMS
    }

    bucket_key_enabled = true
  }
}

# Reglas de ciclo de vida (opcional)
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  count  = var.apply_lifecycle_rules ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id # Aplica el lifecycle solo si apply_lifecycle_rules es true

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id = rule.value.id

      filter {
        and {
          prefix                   = rule.value.prefix
          object_size_greater_than = rule.value.object_size_greater_than
          object_size_less_than    = rule.value.object_size_less_than
        }
      }

      expiration {
        days = rule.value.expiration_days
      }

      status = rule.value.status
    }
  }
}

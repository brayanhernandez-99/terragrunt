resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  tags   = var.bucket_tags
}

# Reglas de ciclo de vida (opcional)
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  count  = var.apply_lifecycle_rules ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id # Aplica el lifecycle solo si apply_lifecycle_rules es true

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id

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
resource "aws_s3_bucket_policy" "enforce_sse" {
  count  = var.enable_put_object_encryption_policy ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyIncorrectEncryptionHeader",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:PutObject",
        Resource  = "arn:aws:s3:::${var.bucket_name}/*",
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = "AES256"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "enforce_sse_ip" {
  count  = var.enable_put_object_encryption_policy_ip ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Bloquea PUT sin AES256
      {
        Sid       = "DenyIncorrectEncryptionHeader",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:PutObject",
        Resource  = "arn:aws:s3:::${var.bucket_name}/*",
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = "AES256"
          }
        }
      },

      # Permite GET solo a ciertas IPs
      {
        Sid       = "AllowGetObjectFromSpecificIPs",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${var.bucket_name}/*",
        Condition = {
          IpAddress = {
            "aws:SourceIp" = var.allowed_ips
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  count  = var.enable_object_ownership_controls ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    object_ownership = var.object_ownership_type
  }
}


resource "aws_s3_bucket_cors_configuration" "cors" {
  count  = var.enable_cors ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_headers = lookup(cors_rule.value, "AllowedHeaders", null)
      allowed_methods = lookup(cors_rule.value, "AllowedMethods", null)
      allowed_origins = lookup(cors_rule.value, "AllowedOrigins", null)
      expose_headers  = lookup(cors_rule.value, "ExposeHeaders", [])
      max_age_seconds = lookup(cors_rule.value, "MaxAgeSeconds", null)
    }
  }
}
resource "aws_s3_bucket_public_access_block" "public_access" {
  count  = var.enable_public_access_block ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = var.val_public_access_block
  ignore_public_acls      = var.val_public_access_block
  block_public_policy     = var.val_public_access_block
  restrict_public_buckets = var.val_public_access_block
}
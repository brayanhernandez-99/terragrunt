resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  tags   = var.bucket_tags
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

# resource "aws_s3_bucket_acl" "acl" {
#   bucket      = aws_s3_bucket.my_bucket.id
#   acl         = "public-read"
#   depends_on  = [aws_s3_bucket_ownership_controls.ownership]
# }
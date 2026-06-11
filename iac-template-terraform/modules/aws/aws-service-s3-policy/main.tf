resource "aws_s3_bucket_policy" "policy" {
  bucket = var.s3_bucket_id
  policy = jsonencode(var.s3_bucket_policy)
}

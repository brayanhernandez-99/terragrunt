variable "s3_bucket_id" {
  description = "ID (nombre) del bucket S3"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN del bucket S3"
  type        = string
}

variable "s3_bucket_policy" {
  description = "JSON de la Policy del bucket S3"
  type        = any
}

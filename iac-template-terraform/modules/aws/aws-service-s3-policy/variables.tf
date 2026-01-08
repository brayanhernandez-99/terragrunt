variable "s3_bucket_id" {
  description = "Nombre del bucket S3 para asociar la política."
  type        = string
}

variable "bucket_resource_arn" {
  description = "ARN del bucket S3 que se usará como recurso en la política."
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "ARN de la distribución de CloudFront para restringir el acceso."
  type        = string
}

variable "s3_bucket_name" {
  description = "Nombre del backet"
  type = string
}

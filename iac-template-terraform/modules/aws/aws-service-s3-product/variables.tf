# variables datos basicos
variable "bucket_name" {
  description = "El nombre del bucket S3"
  type        = string
}

variable "bucket_tags" {
  description = "Un mapa de etiquetas (tags) para el bucket S3"
  type        = map(string)
  default = {

  }
}

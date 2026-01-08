variable "Domain_name" {
  description = "Domain name para apis"
  type        = string
}

variable "arn_certificate" {
  description = "arn del certificado"
  type        = string
}

variable "api_id" {
  description = "id de la api"
  type        = string
}

variable "stage_name" {
  description = "stage para el api mapping"
  type        = string
}

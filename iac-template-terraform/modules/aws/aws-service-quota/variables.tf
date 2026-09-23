variable "service_code" {
  description = "Código del servicio de AWS al que pertenece la cuota"
  type        = string
}

variable "quota_code" {
  description = "Código de la cuota de servicio de AWS"
  type        = string
}

variable "quota_value" {
  description = "Valor configurado para la cuota de servicio"
  type        = number
}

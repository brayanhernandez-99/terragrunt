variable "name" {
  description = "Nombre del namespace"
  type        = string
}

variable "vpc_id" {
  description = "VPC donde se crea el namespace"
  type        = string
}

variable "description" {
  description = "Descripción del namespace"
  type        = string
  default     = null
}

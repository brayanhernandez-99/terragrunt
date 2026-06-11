variable "name" {
  description = "Nombre de la custom cache policy"
  type        = string
}

variable "comment" {
  description = "Descripcion de la custom cache policy"
  type        = string
}

variable "default_ttl" {
  description = "TTL (Tiempo de vida) predeterminado para el comportamiento de la caché"
  type        = number
}

variable "min_ttl" {
  description = "Tiempo mínimo que un objeto permanecerá en caché (segundos)"
  type        = number
}

variable "max_ttl" {
  description = "TTL máximo para el comportamiento de la caché"
  type        = number
}

variable "name" {
  description = "Nombre del RDS Proxy (debe ser único en la región)."
  type        = string
}

variable "role_arn" {
  description = "ARN del IAM role usado por el proxy para acceder a Secrets Manager y la BD."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets privadas donde se despliega el RDS Proxy."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Groups asociados al RDS Proxy para control de red."
  type        = list(string)
}

variable "secret_names" {
  description = "Lista de nombres de Secrets Manager con credenciales de la base de datos."
  type        = list(string)
}

variable "db_cluster_identifier" {
  description = "Identificador del cluster RDS asociado al proxy."
  type        = string
}

variable "max_connections_percent" {
  description = "Porcentaje máximo de conexiones que puede usar el proxy."
  type        = number
}

variable "max_idle_connections_percent" {
  description = "Porcentaje máximo de conexiones inactivas en el pool."
  type        = number
}

variable "connection_borrow_timeout" {
  description = "Tiempo en segundos que espera el proxy por una conexión libre."
  type        = number
}

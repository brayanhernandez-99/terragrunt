variable "cache_name" {
  description = "Nombre del ElastiCache (Valkey)"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnets donde se desplegará el cache"
  type        = list(string)
}

variable "security_group_ids" {
  type        = list(string)
  description = "IDs de los Security Groups"
}

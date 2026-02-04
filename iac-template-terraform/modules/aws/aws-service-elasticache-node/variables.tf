variable "cache_name" {
  description = "Nombre del ElastiCache (Valkey)"
  type        = string
}

variable "subnet_group_name" {
  description = "Nombre del subnet group de ElastiCache"
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

variable "target_group_config" {
  description = "Configuración del Target Group."
  type = object({
    name                  = string
    port                  = number
    vpc_id                = string
    health_check_port     = string
    health_check_interval = number
    health_check_timeout  = number
    healthy_threshold     = number
    unhealthy_threshold   = number
  })
}

variable "nlb_arn" {
  description = "ARN del Loand Balancer"
  type        = string
}

variable "listener_port" {
  description = "Puerto del listener"
  type        = number
  default     = 6379
}

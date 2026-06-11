variable "api_name" {
  description = "Nombre de la API Gateway"
  type        = string
}

variable "stage_name" {
  description = "Nombre del stage donde se desplegará la API"
  type        = string
}

variable "api_endpoint_type" {
  description = "Tipo de endpoint de la API Gateway (REGIONAL, EDGE, PRIVATE)"
  type        = string
}

variable "vpc_link" {
  description = "vpc link asociado a la api gateway"
  type        = string
}

variable "nlb_dns_name" {
  description = "dns del load balancer"
  type        = string
}

variable "nlb_listener" {
  description = "listener del load balancer"
  type        = string
}

variable "role_arn" {
  type        = string
  description = "ARN del IAM Role"
}

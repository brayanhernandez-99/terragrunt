variable "api_name" {
  description = "Nombre de la API Gateway"
  type        = string
}

variable "http_method" {
  description = "Método HTTP a ser usado en la API"
  type        = string
}

variable "integration_type" {
  description = "Tipo de integración de API Gateway (MOCK, HTTP, AWS_PROXY)"
  type        = string
}

variable "stage_name" {
  description = "Nombre del stage donde se desplegará la API"
  type        = string
}

variable "path_part" {
  description = "Segmento del path de la API"
  type        = string
}

variable "authorization_type" {
  description = "Tipo de autorización a utilizar para el método HTTP"
  type        = string
}

variable "api_endpoint_type" {
  description = "Tipo de endpoint de la API Gateway (REGIONAL, EDGE, PRIVATE)"
  type        = string
}

variable "request_template" {
  description = "Plantilla de solicitud única para API Gateway"
  type        = string
}

variable "vpc_link" {
  description = "vpc link asociado a la api gateway"
  type        = string
}

variable "nlb_arn" {
  description = "arn del load balancer"
  type        = string
}

variable "nlb_dns_name" {
  description = "dns del load balancer"
  type        = string
}

variable "port_cluster" {
  description = "port cluster"
  type        = string
}
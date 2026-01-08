variable "vpc_id" {
  description = "El bloque CIDR para la VPC"
  type        = string
}

variable "service_name" {
  description = "service name"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs de las subnets donde se ejecutarán los servicios ECS"
  type        = list(string)
}

variable "sg_id" {
  description = "SG para endpoint"
  type        = string
}

variable "name_endpoint" {
  description = "name endpoint"
  type        = string
}
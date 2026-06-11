variable "vpc_id" {
  description = "El bloque CIDR para la VPC"
  type        = string
}

variable "service_name" {
  description = "service name"
  type        = string
}

variable "name_endpoint" {
  description = "name endpoint"
  type        = string
}

variable "route_table_id" {
  type        = list(string)
  description = "List of route table IDs to associate"
}
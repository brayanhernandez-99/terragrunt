# Variables para el módulo de VPC
variable "vpc_cidr_block" {
  description = "El bloque CIDR para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Nombre de la VPC
variable "vpc_name" {
  description = "Nombre de la VPC"
  type        = string
  default     = "mi-vpc"
}

# Subnets públicas
variable "public_subnets" {
  description = "Mapa de subnets públicas con CIDR blocks y zonas de disponibilidad"
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {

  }
}

# Subnets privadas
variable "private_subnets" {
  description = "Mapa de subnets privadas con CIDR blocks y zonas de disponibilidad"
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {

  }
}

# Reglas NACL para subnets públicas como mapa
variable "public_nacl_rules" {
  description = "Reglas para el NACL de subnets públicas"
  type = map(object({
    rule_number = number
    egress      = bool
    protocol    = string
    cidr_block  = string
    rule_action = string
    from_port   = number
    to_port     = number
  }))
  default = {

  }
}

# Reglas NACL para subnets privadas como mapa
variable "private_nacl_rules" {
  description = "Reglas para el NACL de subnets privadas"
  type = map(object({
    rule_number = number
    egress      = bool
    protocol    = string
    cidr_block  = string
    rule_action = string
    from_port   = number
    to_port     = number
  }))
  default = {

  }
}

# VPC Endpoints
variable "vpc_endpoints" {
  description = "Configuración de VPC Endpoints por tipo"
  type = map(object({
    service_name = string
  }))
  default = {

  }
}

# ID del Transit Gateway para las subredes privadas
variable "transit_gateway_id" {
  description = "ID del Transit Gateway para las subredes privadas"
  type        = string
  default     = ""
}

variable "cidr_block_gw_local_public" {
  description = "cidr block para gw local público "
  type        = string
  default     = "10.3.32.0/20"
}

variable "cidr_block_gw_vgw_public" {
  description = "cidr block para gw local público "
  type        = string
  default     = "172.17.0.0/16"
}

variable "cidr_block_gw_local_private" {
  description = "cidr block para gw local público "
  type        = string
  default     = "10.3.32.0/20"
}

variable "cidr_block_gw_vgw_private" {
  description = "cidr block para gw local público "
  type        = string
  default     = "172.17.0.0/16"
}

# Nombre de la VPC
# variable "cgw_ip" {
#   description = "IP Adress para cgw"
#   type        = string
#   default     = "10.0.0.0/16"
# }

# variable "device_name"{
#   description = "Nombre del device para el customerGatewat"
#   type = string
#   default = "VPN-IPSEC-UNE"
# }

# variable "cgw_ip_terramark" {
#   description = "IP Adress para cgw"
#   type        = string
#   default     = "10.0.0.0/16"
# }

# variable "device_name_terramark"{
#   description = "Nombre del device para el customerGatewat"
#   type = string
#   default = "VPN-IPSEC-UNE"
# }

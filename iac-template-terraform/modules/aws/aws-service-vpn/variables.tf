# ID de la VPC
variable "vpc_id" {
  description = "ID de la vpc"
  type        = string
  default     = "mi-vpc"
}

# ID cgw
variable "cgw_id" {
  description = "ID de la vpc"
  type        = string
  default     = ""
}

# ID cgw
variable "remote_ipv4_network_cidr" {
  description = "remote_ipv4_network_cidr para vpn"
  type        = string
  default     = ""
}

# ID cgw
variable "local_ipv4_network_cidr" {
  description = "local_ipv4_network_cidr para la vpn"
  type        = string
  default     = ""
}

variable "vpn_name" {
  description = "nombre de la vpn"
  type        = string
  default     = "vpn"
}

variable "vgw_id" {
  description = "vgw id"
  type        = string
  default     = "vpn"
}

variable "static_routes" {
  type    = list(string)
  default = ["192.168.1.0/24", "192.168.2.0/24"]
}
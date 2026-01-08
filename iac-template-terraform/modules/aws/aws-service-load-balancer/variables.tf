variable "nlb_name" {
  description = "Nombre del Network Load Balancer"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnets para el NLB"
  type        = list(string)
}




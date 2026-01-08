# Variables para el nombre del servicio ECS
variable "name_sg" {
  description = "Nombre SG"
  type = string
}

variable "description" {
  type        = string
  default     = "Security group managed by Terraform"
}

variable "vpc_id" {
  description = "El bloque CIDR para la VPC"
  type        = string
}

variable "ingress" {
  type = list(object({
    description = optional(string)
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string))
  }))
  default = []
}

variable "egress" {
  type = list(object({
    description = optional(string)
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string))
  }))
  default = []
}
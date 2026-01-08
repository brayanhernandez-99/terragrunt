variable "instance_name" {
  type        = string
  default     = "ftp-instance"
  description = "Nombre de la instancia EC2"
}

variable "ami" {
  type        = string
  default     = "ami-08c40ec9ead489470"
  description = "AMI de Ubuntu 22.04 LTS"
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Tipo de instancia EC2"
}

variable "subnet_id" {
  type        = string
  description = "ID de la subnet donde se desplegará la instancia"
}

variable "sg_id" {
  type        = string
  description = "ID del Security Group asociado a la instancia"
}

variable "instance_profile_name" {
  description = "Nombre del IAM Instance Profile asignado a la instancia EC2"
  type        = string
}

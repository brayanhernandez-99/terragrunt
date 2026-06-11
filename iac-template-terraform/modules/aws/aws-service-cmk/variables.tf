variable "aws_account_id" {
  description = "AWS Account ID para la política KMS"
  type        = string
}

variable "name_cmk" {
  description = "Nombre de la clave KMS"
  type        = string
}
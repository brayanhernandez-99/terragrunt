# Variable para crear solo el cluster
variable "name_policy_syn" {
  description = "Nombre de la policy syn"
  type        = string
}

variable "name_policy_notifier" {
  description = "Nombre de la policy notifier"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID para la política KMS"
  type        = string
}
variable "scheduler_name" {
  description = "Nombre del scheduler"
  type        = string
}

variable "description" {
  description = "Descripción del scheduler"
  type        = string
}


variable "aws_account_id" {
  description = "AWS Account ID para la política KMS"
  type        = string
}

variable "kinesis_name" {
  description = "Nombre del stream de Kinesis"
  type        = string
}

variable "schedule_expression" {
  description = "Expresión de cron o rate para el scheduler"
  type        = string
}

variable "payload" {
  type        = string
  description = "Payload JSON para enviar al stream de Kinesis"
}

variable "kms_key_arn" {
  type        = string
  description = "ARN de la clave KMS para cifrado"
}

variable "iam_role_arn" {
  type        = string
  description = "ARN del rol IAM para el scheduler"
}

variable "kinesis_partition_key" {
  description = "Partition key para Kinesis (opcional)"
  type        = string
  default     = null
}
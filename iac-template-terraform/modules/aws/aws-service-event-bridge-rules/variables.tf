variable "rule_name" {
  description = "Nombre del scheduler"
  type        = string
}

variable "description" {
  description = "Descripción del rule"
  type        = string
}

variable "iam_role_arn" {
  description = "ARN del rol IAM para EventBridge"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID para la política KMS"
  type        = string
}

variable "target_id" {
  type        = string
  description = "ID del target"
}

variable "event_pattern" {
  type        = any
  description = "Patrón de evento para el rule"
}

variable "input_paths" {
  type        = map(string)
  description = "Patrón de evento para el rule"
}

variable "input_template" {
  type        = string
  description = "Patrón de evento para el rule"
}
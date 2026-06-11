variable "rule_name" {
  description = "Nombre del scheduler"
  type        = string
}

variable "description" {
  description = "Descripción del rule"
  type        = string
}

variable "role_arn" {
  description = "ARN del rol IAM para EventBridge"
  type        = string
}

variable "target_id" {
  type        = string
  description = "ID del target"
}

variable "target_arn" {
  description = "ARN del target"
  type        = string
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
  type        = any
  description = "Patrón de evento para el rule"
}

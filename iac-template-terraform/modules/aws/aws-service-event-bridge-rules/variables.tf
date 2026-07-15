variable "rule_name" {
  description = "Nombre de la regla de EventBridge"
  type        = string
}

variable "description" {
  description = "Descripción de la regla"
  type        = string
}

variable "role_arn" {
  description = "ARN del rol IAM para EventBridge"
  type        = string
}

variable "target_id" {
  description = "ID del target"
  type        = string
}

variable "target_arn" {
  description = "ARN del target"
  type        = string
}

variable "event_pattern" {
  description = "Patrón de eventos de EventBridge"
  type        = any
}

variable "input_paths" {
  description = "Mapeo de variables para el Input Transformer"
  type        = map(string)
}

variable "input_template" {
  description = "Plantilla JSON del Input Transformer"
  type        = string
}

variable "role_name" {
  type        = string
  description = "Nombre del IAM Role"
}

variable "assume_role_policy" {
  type        = any
  description = "Trust policy (assume role) en formato JSON"
}

variable "policy" {
  type        = any
  description = "IAM inline policy (opcional) en formato JSON"
  default     = null
}

variable "managed_policy_arns" {
  type        = list(string)
  description = "AWS Managed Policy ARNs a adjuntar (opcional)"
  default     = null
}

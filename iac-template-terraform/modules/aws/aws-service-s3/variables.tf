# variables datos basicos
variable "bucket_name" {
  description = "El nombre del bucket S3"
  type        = string
}

variable "bucket_tags" {
  description = "Un mapa de etiquetas (tags) para el bucket S3"
  type        = map(string)
  default = {

  }
}

#variables del cliclo de vida del
variable "apply_lifecycle_rules" {
  description = "Indica si se debe aplicar reglas de ciclo de vida al bucket S3"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "Lista de reglas de ciclo de vida para el bucket S3"
  type        = list(object({
    id                       = string
    status                   = string
    prefix                   = string
    object_size_greater_than = number
    object_size_less_than    = number
    expiration_days          = number
  }))
  default = [
    {
      id                       = "default-rule"
      status                   = "Enabled"
      prefix                   = ""
      object_size_greater_than = 0
      object_size_less_than    = 0
      expiration_days          = 30
    }
  ]
}

variable "enable_put_object_encryption_policy" {
  type    = bool
  default = false
}

variable "enable_object_ownership_controls" {
  type    = bool
  default = false
}

variable "object_ownership_type" {
  type    = string
  default = "BucketOwnerEnforced"
}

variable "enable_cors" {
  type    = bool
  default = false
}

variable "cors_rules" {
  type    = list(any)
  default = []
}

variable "enable_put_object_encryption_policy_ip" {
  type    = bool
  default = false
}

variable "allowed_ips" {
  type    = list(string)
  default = []
}

variable "enable_public_access_block" {
  type    = bool
  default = false
}

variable "val_public_access_block" {
  type    = bool
  default = true
}
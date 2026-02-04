variable "user_pool_name" {
  description = "Nombre del User Pool de Cognito"
  type        = string
}

variable "username_attributes" {
  description = "Opciones para inicio de sesión en el User Pool (email, phone_number, etc.)"
  type        = list(string) # Se puede cambiar por ["email"] , ["phone_number"], ["email", "phone_number"], etc.
}

variable "password_min_length" {
  description = "Longitud mínima de la contraseña"
  type        = number
}

variable "password_require_uppercase" {
  description = "Requerir mayúsculas en la contraseña"
  type        = bool
}

variable "password_require_lowercase" {
  description = "Requerir minúsculas en la contraseña"
  type        = bool
}

variable "password_require_numbers" {
  description = "Requerir números en la contraseña"
  type        = bool
}

variable "password_require_symbols" {
  description = "Requerir símbolos en la contraseña"
  type        = bool
}

variable "auto_verified_attributes" {
  description = "Atributos verificados automáticamente (email o phone_number)"
  type        = list(string) #  Puedes agregar "email", "phone_number" si es necesario
}

variable "mfa_configuration" {
  description = "Configuración de MFA (ON, OFF, OPTIONAL)"
  type        = string # Puede ser "OPTIONAL" , "ON", "OFF", o "OPTIONAL"
}

variable "custom_attributes" {
  description = "Mapa de atributos personalizados"
  type = map(object({
    mutable    = optional(bool)   # Define que es opcional y de tipo booleano
    min_length = optional(number) # Define que es opcional y de tipo número
    max_length = optional(number) # Define que es opcional y de tipo número
  }))
}

variable "verification_template" {
  description = "Template para el mensaje de verificación"
  type = object({
    email_subject        = string
    email_message        = string
    sms_message          = string
    default_email_option = string
  })
}

variable "invitation_template" {
  description = "Template para el mensaje de invitación"
  type = object({
    email_subject = string
    email_message = string
    sms_message   = string
  })
}

variable "sms_message" {
  description = "Template para el mensaje MFA"
  type        = string
}

variable "app_client_name" {
  description = "Nombre del App Client"
  type        = string
  default     = "value"
}

variable "generate_secret" {
  description = "Generar secreto para el App Client"
  type        = bool
  default     = false
}

variable "allowed_oauth_flows" {
  description = "Flujos de OAuth permitidos"
  type        = list(string)
  default     = []
}

variable "allowed_authentication_flows" {
  description = "Lista de flujos de autenticación"
  type        = list(string)
  default     = []
}

variable "allowed_oauth_scopes" {
  description = "Ámbitos de OAuth permitidos"
  type        = list(string)
  default     = []
}

variable "callback_urls" {
  description = "Lista de URLs de callback permitidas"
  type        = list(string)
  default     = []
}

variable "logout_urls" {
  description = "Lista de URLs de logout permitidas"
  type        = list(string)
  default     = []
}

variable "supported_identity_providers" {
  description = "Proveedores de identidad soportados"
  type        = list(string)
  default     = []
}

variable "access_token_validity" {
  description = "Duración de validez del token de acceso en días"
  type        = number
  default     = 0
}

variable "id_token_validity" {
  description = "Duración de validez del token de ID en días"
  type        = number
}

variable "refresh_token_validity" {
  description = "Duración de validez del token de actualización en días"
  type        = number
}

variable "enable_token_revocation" {
  description = "Habilitar revocación de tokens"
  type        = bool
}

variable "message_lambda_arn" {
  description = "ARN de Lambda Function  Message"
  type        = string
  default     = ""
}

variable "pre_authentication_lambda_arn" {
  description = "ARN de Lambda Function Pre Authentication"
  type        = string
  default     = ""
}

variable "pre_token_generation_lambda_arn" {
  description = "ARN de Lambda Function Pre Token Generation"
  type        = string
  default     = ""
}

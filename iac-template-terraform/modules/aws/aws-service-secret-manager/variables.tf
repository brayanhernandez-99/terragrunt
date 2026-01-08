variable "secret_name" {
  type = string
  description = "The name of the secret containing the password to pass"
}

variable "secret_tags" {
  description = "Tags to set for all resources"
  type = map(string)
  default = {}
}

variable "secret_description" {
  description = "The description for the secret"
  type = string
}

variable "secret_string_value" {
  description = "The password value to set for each secret values"
  type = map(string)
  default = {}
}

variable "kms_key_id" {
  type        = string
  default = null
  description = "The key id to use when creating keys"
}
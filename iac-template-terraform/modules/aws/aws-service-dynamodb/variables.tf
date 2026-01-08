variable "name_table_dynamo" {
  description = "Nombre de la tabla de dynamo"
  type = string
}
variable "attribute_name" {
  description = "Nombre del atributo de la tabla de dynamo"
  type = string
  default = "id"
}
variable "attribute_type" {
  description = "Nombre del atributo de la tabla de dynamo"
  type = string
  default = "S"
}
variable "dynamodb_insert_items" {
  description = "Define si se deben insertar ítems en la tabla DynamoDB"
  type        = bool
  default     = false 
}
variable "dynamodb_items_json" {
  description = "Lista de items en formato JSON a insertar en la tabla DynamoDB"
  type        = list(string)
  default     = []
}
variable "use_sort_key" {
  description = "Define si la tabla DynamoDB debe tener un sort key"
  type        = bool
  default     = false
}

variable "sort_key_name" {
  description = "Nombre del sort key (si se usa)"
  type        = string
  default     = "sort_key"
}

variable "sort_key_type" {
  description = "Tipo de dato del sort key (si se usa)"
  type        = string
  default     = "S" 
}
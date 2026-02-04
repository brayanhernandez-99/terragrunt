variable "ssm_parameters" {
  type = map(object({
    type : string
    name : string
    description : string
    key_id : optional(string)
    value : string
    tags : optional(map(string))
  }))
  description = "Mapa de parametros para SSM Parameter store"
  default = {
  }
}
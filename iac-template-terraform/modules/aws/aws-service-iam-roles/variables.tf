variable "iam_role_name" {
  description = "IAM Role Name"
  type        = string
}

variable "iam_policies_map" {
  description = "Map de políticas a asociar con el rol IAM"
  type = map(object({
    name        = string
    policy_json = optional(string) 
    managed_arn = optional(string)
    use_suffix  = optional(bool, true)
  }))
}

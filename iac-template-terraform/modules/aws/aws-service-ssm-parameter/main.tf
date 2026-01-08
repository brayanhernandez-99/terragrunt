resource "aws_ssm_parameter" "ssm-param-customer"{
  for_each    = var.ssm_parameters
  name        = each.value.name
  description = lookup(each.value, "description", null)
  type        = each.value.type != null ? each.value.type  : "String" ? "SecureString" : "String"
  value       = each.value.value
  key_id      = lookup(each.value, "key_id", null)
  tags        = lookup(each.value, "tags", null)
  tier        = "Advanced"
}
resource "aws_servicequotas_service_quota" "quota" {
  service_code = var.service_code
  quota_code   = var.quota_code
  value        = var.quota_value
}

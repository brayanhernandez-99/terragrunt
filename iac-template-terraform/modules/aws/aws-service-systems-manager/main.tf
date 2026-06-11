resource "aws_ssm_service_setting" "parameter_store_throughput" {
  setting_id    = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:servicesetting/ssm/parameter-store/high-throughput-enabled"
  setting_value = var.parameter_store_high_throughput_enabled
}

resource "aws_ssm_service_setting" "parameter_store_default_tier" {
  setting_id    = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:servicesetting/ssm/parameter-store/default-parameter-tier"
  setting_value = var.parameter_default_tier
}
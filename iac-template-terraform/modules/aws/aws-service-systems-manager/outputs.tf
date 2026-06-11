output "parameter_store_throughput_setting_value" {
  description = "Current value of the high throughput setting"
  value       = aws_ssm_service_setting.parameter_store_throughput.setting_value
}

output "parameter_store_default_tier_setting_value" {
  description = "Current value of the default parameter tier setting"
  value       = aws_ssm_service_setting.parameter_store_default_tier.setting_value
}

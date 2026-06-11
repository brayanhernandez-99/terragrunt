variable "aws_region" {
  description = "AWS region where the SSM settings will be applied"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID used to construct the SSM service setting ARN"
  type        = string
}

variable "parameter_store_high_throughput_enabled" {
  description = "Enable higher throughput for SSM Parameter Store. Set to 'true' for Up to 10,000 TPS, 'false' for standard throughput (1,000 TPS)"
  type        = string
}

variable "parameter_default_tier" {
  description = "Default tier for SSM Parameter Store. Valid values: Standard, Advanced, Intelligent-Tiering"
  type        = string
  default     = "Standard"
}

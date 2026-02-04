resource "aws_scheduler_schedule" "kinesis_scheduler" {
  name                         = var.scheduler_name
  description                  = var.description
  schedule_expression          = var.schedule_expression
  schedule_expression_timezone = "America/Bogota"
  flexible_time_window {
    mode = "OFF"
  }

  kms_key_arn = var.kms_key_arn

  target {
    arn      = "arn:aws:kinesis:us-east-1:${var.aws_account_id}:stream/${var.kinesis_name}"
    role_arn = var.iam_role_arn
    input    = var.payload

    dynamic "kinesis_parameters" {
      for_each = var.kinesis_partition_key != null ? [1] : []
      content {
        partition_key = var.kinesis_partition_key
      }
    }
  }
}
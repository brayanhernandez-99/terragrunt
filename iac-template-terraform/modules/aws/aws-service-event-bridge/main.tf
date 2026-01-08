resource "aws_scheduler_schedule" "kinesis_scheduler" {
  name                 = var.scheduler_name
  description          = "Scheduler sorteo automático"
  schedule_expression  = var.schedule_expression
  schedule_expression_timezone = "America/Bogota"
  flexible_time_window {
    mode = "OFF"
  }

  kms_key_arn = var.kms_key_arn

  target {
    arn      = "arn:aws:kinesis:us-east-1:${var.aws_account_id}:stream/${var.kinesis_name}"
    role_arn = aws_iam_role.eventbridge_scheduler_role.arn
    input    = var.payload

    kinesis_parameters {
      partition_key = "sha-000000000000000001"
    }
  }
  
}

# Rol IAM que permite al scheduler publicar en Kinesis
resource "aws_iam_role" "eventbridge_scheduler_role" {
  name = "${var.kinesis_name}-eventbridge-scheduler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "eventbridge_scheduler_policy" {
  name = "${var.kinesis_name}-eventbridge-scheduler-policy"
  role = aws_iam_role.eventbridge_scheduler_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:*",
          "kms:*"
        ]
        Resource = "*"
      }
    ]
  })
}
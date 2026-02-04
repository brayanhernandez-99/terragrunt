# Rol IAM que permite al scheduler publicar en Kinesis
resource "aws_iam_role" "eventbridge_scheduler_role" {
  name = "custom-eventbridge-scheduler-role"

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
  name   = "custom-eventbridge-scheduler-policy"
  role   = aws_iam_role.eventbridge_scheduler_role.id
  policy = jsonencode(var.eventbridge_scheduler_policy)
}
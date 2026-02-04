resource "aws_cloudwatch_event_rule" "eventbridge_rule" {
  name          = var.rule_name
  description   = var.description
  event_pattern = jsonencode(var.event_pattern)
}


resource "aws_cloudwatch_event_target" "kinesis" {
  rule      = aws_cloudwatch_event_rule.eventbridge_rule.name
  target_id = var.target_id
  arn       = "arn:aws:kinesis:us-east-1:${var.aws_account_id}:stream/${var.target_id}"
  role_arn  = var.iam_role_arn

  input_transformer {
    input_paths    = var.input_paths
    input_template = var.input_template
  }
}
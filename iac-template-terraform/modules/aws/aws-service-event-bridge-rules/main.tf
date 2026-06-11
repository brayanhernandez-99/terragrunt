resource "aws_cloudwatch_event_rule" "event" {
  name          = var.rule_name
  description   = var.description
  event_pattern = jsonencode(var.event_pattern)
}

resource "aws_cloudwatch_event_target" "target" {
  rule      = aws_cloudwatch_event_rule.event.name
  target_id = var.target_id
  arn       = var.target_arn
  role_arn  = var.role_arn

  input_transformer {
    input_paths    = var.input_paths
    input_template = jsonencode(var.input_template)
  }
}

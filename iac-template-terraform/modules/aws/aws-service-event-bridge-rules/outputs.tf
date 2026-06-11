output "rule_arn" {
  value = aws_cloudwatch_event_rule.event.arn
}

output "rule_name" {
  value = aws_cloudwatch_event_rule.event.name
}

output "target_id" {
  value = aws_cloudwatch_event_target.target.target_id
}

output "target_arn" {
  value = aws_cloudwatch_event_target.target.arn
}

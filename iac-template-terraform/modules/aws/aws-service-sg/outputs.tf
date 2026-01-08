output "security_group_id" {
  description = "ID of the created Security Group"
  value       = aws_security_group.endpoint.id
}

output "security_group_arn" {
  description = "ARN of the created Security Group"
  value       = aws_security_group.endpoint.arn
}

output "security_group_name" {
  description = "Name of the created Security Group"
  value       = aws_security_group.endpoint.name
}
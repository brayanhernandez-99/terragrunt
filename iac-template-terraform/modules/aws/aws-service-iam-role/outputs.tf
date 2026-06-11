output "role_name" {
  description = "Nombre del IAM Role"
  value       = aws_iam_role.role.name
}

output "role_arn" {
  description = "ARN del IAM Role"
  value       = aws_iam_role.role.arn
}

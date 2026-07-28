output "iam_role_name" {
  description = "Nombre del IAM Role creado para la instancia EC2."
  value       = aws_iam_role.ec2_s3_role.name
}

output "iam_role_arn" {
  description = "ARN del IAM Role creado para la instancia EC2."
  value       = aws_iam_role.ec2_s3_role.arn
}

output "iam_policy_arn" {
  description = "ARN de la IAM Policy adjunta al IAM Role."
  value       = aws_iam_policy.ec2_s3_policy.arn
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_s3_profile.name
}
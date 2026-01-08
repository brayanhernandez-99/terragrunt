output "vpc_endpoint_id" {
  description = "ID of the created VPC Endpoint"
  value       = aws_vpc_endpoint.vpc_endpoint.id
}

output "vpc_endpoint_arn" {
  description = "ARN of the VPC Endpoint"
  value       = aws_vpc_endpoint.vpc_endpoint.arn
}
output "nlb_arn" {
  description = "ARN del Network Load Balancer"
  value       = aws_lb.nlb.arn
}

output "nlb_dns_name" {
  description = "DNS Name del Network Load Balancer"
  value       = aws_lb.nlb.dns_name
}



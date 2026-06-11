resource "aws_service_discovery_private_dns_namespace" "cloudmap" {
  name        = var.name
  description = var.description
  vpc         = var.vpc_id
}

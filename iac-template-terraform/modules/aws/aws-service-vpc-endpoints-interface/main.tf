resource "aws_vpc_endpoint" "vpc_endpoint" {
  vpc_id              = var.vpc_id
  service_name        = var.service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [var.sg_id]
  private_dns_enabled = true

  tags = {
    Name = var.name_endpoint
  }
}
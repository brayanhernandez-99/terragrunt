resource "aws_security_group" "endpoint" {
  name        = var.name_sg
  vpc_id      = var.vpc_id
  description = var.description

  dynamic "ingress" {
    for_each = var.ingress
    content {
      description = lookup(ingress.value, "description", null)
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
    }
  }

  # Egress dinámicos
  dynamic "egress" {
    for_each = var.egress
    content {
      description = lookup(egress.value, "description", null)
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = lookup(egress.value, "cidr_blocks", null)
    }
  }

  tags = {
    Name = var.name_sg
  }
}
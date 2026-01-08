#VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

#Subnets públicas
resource "aws_subnet" "public" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-${each.key}"
  }
}

#Subnets privadas
resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = "${var.vpc_name}-private-${each.key}"
  }
}

# Internet Gateway para subnets públicas
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# resource "aws_vpn_gateway" "vgw" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "${var.vpc_name}-vgw"
#   }
# }

# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "gw" {
  depends_on = [
    aws_internet_gateway.igw
  ]
  tags = {
    Name = "${var.vpc_name}-eip"
  }
}

# Crear un NAT Gateway para las subnets privadas
# resource "aws_nat_gateway" "gw" {
#   # for_each      = aws_subnet.public
#   subnet_id     = aws_subnet.public[element(keys(aws_subnet.public), 0)].id
#   allocation_id = aws_eip.gw.id
#   tags = {
#     Name = "${var.vpc_name}-natgw"
#   }
# }

# Route Table para subnets públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Ruta para que el tráfico 0.0.0.0/0 pase por el Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = var.cidr_block_gw_local_public
    gateway_id = "local"
  }

  # route {
  #   cidr_block = var.cidr_block_gw_vgw_public
  #   gateway_id = aws_vpn_gateway.vgw.id
  # }

  tags = {
    Name = "${var.vpc_name}-public-route-table"
  }
}

# Route Table para subnets privadas (ahora sin NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.gw.id
  # }

  route {
    cidr_block = var.cidr_block_gw_local_private
    gateway_id = "local"
  }

  # route {
  #   cidr_block = var.cidr_block_gw_vgw_private
  #   gateway_id = aws_vpn_gateway.vgw.id
  # }

  tags = {
    Name = "${var.vpc_name}-private-route-table"
  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.private.id
}

# Asociar la Route Table pública a las subnets públicas
resource "aws_route_table_association" "public_association" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Asociar la Route Table privada a las subnets privadas
resource "aws_route_table_association" "private_association" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# Network ACL para subnets públicas
resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-public-nacl"
  }
}

# Reglas dinámicas para el NACL de las subnets públicas
resource "aws_network_acl_rule" "public_rules" {
  for_each = var.public_nacl_rules

  network_acl_id = aws_network_acl.public.id
  rule_number    = each.value.rule_number
  egress         = each.value.egress
  protocol       = each.value.protocol
  cidr_block     = each.value.cidr_block
  rule_action    = each.value.rule_action
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}


# Network ACL para subnets privadas
resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-private-nacl"
  }
}

# Reglas dinámicas para el NACL de las subnets privadas
resource "aws_network_acl_rule" "private_rules" {
  for_each = var.private_nacl_rules

  network_acl_id = aws_network_acl.private.id
  rule_number    = each.value.rule_number
  egress         = each.value.egress
  protocol       = each.value.protocol
  cidr_block     = each.value.cidr_block
  rule_action    = each.value.rule_action
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

# Asociar NACL a subnets públicas
resource "aws_network_acl_association" "public_association" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.public.id
}

# Asociar NACL a subnets privadas
resource "aws_network_acl_association" "private_association" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.private.id
}

resource "aws_vpc_endpoint" "gateway_endpoints" {
  for_each          = var.vpc_endpoints
  vpc_id            = aws_vpc.main.id
  service_name      = each.value.service_name
  vpc_endpoint_type = "Gateway"

  # Asociar con la route table privada
  route_table_ids = [aws_route_table.private.id]

  tags = {
    Name = "${var.vpc_name}-${each.key}-endpoint"
  }
}

# Crear el attachment entre el Transit Gateway y la VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_attachment" {
  count              = var.transit_gateway_id != "" ? 1 : 0
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = aws_vpc.main.id
  subnet_ids         = [for subnet in aws_subnet.private : subnet.id]
  tags = {
    Name = "${var.vpc_name}-transit-gateway-attachment"
  }
}

#Agregar una ruta en la tabla de enrutamiento privada existente para enrutar el tráfico al Transit Gateway
# resource "aws_route" "private_to_transit_gateway" {
#   count = var.transit_gateway_id != "" ? 1 : 0

#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   transit_gateway_id     = var.transit_gateway_id
#   depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc_attachment]
# }

resource "aws_db_subnet_group" "default" {
  name       = "${lower(var.vpc_name)}-db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
  tags = {
    Name : "${var.vpc_name}-db_subnet_group"
  }
}

#Ruta on-premise
# resource "aws_customer_gateway" "cgw" {
#   bgp_asn    = 65000
#   ip_address = var.cgw_ip 
#   type       = "ipsec.1"
#   device_name = var.device_name

#   tags = {
#     Name = "ASA-UNE"
#   }
# }

# resource "aws_customer_gateway" "cgwTerra" {
#   bgp_asn    = 65000
#   ip_address = var.cgw_ip_terramark
#   type       = "ipsec.1"
#   device_name = var.device_name_terramark

#   tags = {
#     Name = "ASA-TERREMARK"
#   }
# }

resource "aws_security_group" "db" {
  vpc_id      = aws_vpc.main.id
  name        = "db-security-group"
  description = "Allow egress and ingress traffic for RDS"

  ingress {
    description = "MySQL/Aurora ingress traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
  tags = {
    Name = "db-security-group"
  }
}

# Crear un grupo de seguridad para los servicios ECS
resource "aws_security_group" "ecs_task" {
  vpc_id      = aws_vpc.main.id
  name        = "ecs-task-group"
  description = "Allow egress and ingress traffic for ECS"

  ingress {
    description = "HTTP ingress traffic access on 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
  ingress {
    description = "HTTP ingress traffic access on 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
  ingress {
    description = "HTTP ingress traffic access on 8443"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.vpc_name}-ecs-security-group"
  }
}

# Crear un grupo de seguridad para fortigate private
resource "aws_security_group" "SG-FortigatePrivate" {
  vpc_id      = aws_vpc.main.id
  name        = "SG-FortigatePrivate"
  description = "Allow egress and ingress traffic for Fortigate"

  ingress {
    description = "HTTP ingress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.vpc_name}-sg-fortigate-private"
  }
}

# Crear un grupo de seguridad para fortigate public
resource "aws_security_group" "SG-FortigatePublic" {
  vpc_id      = aws_vpc.main.id
  name        = "SG-FortigatePublic"
  description = "Allow egress and ingress traffic for Fortigate"

  ingress {
    description = "TCP 444 from 10.150.0.221 (Publisher)"
    from_port   = 444
    to_port     = 444
    protocol    = "tcp"
    cidr_blocks = ["10.150.0.221/32"]
  }
  ingress {
    description = "TCP 444 from 190.71.228.82"
    from_port   = 444
    to_port     = 444
    protocol    = "tcp"
    cidr_blocks = ["190.71.228.82/32"]
  }
  ingress {
    description = "TCP 444 from 190.0.61.178"
    from_port   = 444
    to_port     = 444
    protocol    = "tcp"
    cidr_blocks = ["190.0.61.178/32"]
  }
  ingress {
    description = "UDP 500 from anywhere"
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "UDP 4500 from anywhere"
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.vpc_name}-sg-fortigate-public"
  }
}

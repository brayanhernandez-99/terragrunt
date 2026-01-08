resource "aws_vpn_connection" "vpn" {
  customer_gateway_id = var.cgw_id
  vpn_gateway_id      = var.vgw_id
  type                = "ipsec.1"
  static_routes_only  = true 
  local_ipv4_network_cidr = var.local_ipv4_network_cidr
  remote_ipv4_network_cidr = var.remote_ipv4_network_cidr
  tags = {
    Name = var.vpn_name
  }
}

resource "aws_vpn_connection_route" "vpn_routes" {
  for_each = toset(var.static_routes)

  destination_cidr_block = each.value
  vpn_connection_id      = aws_vpn_connection.vpn.id
}
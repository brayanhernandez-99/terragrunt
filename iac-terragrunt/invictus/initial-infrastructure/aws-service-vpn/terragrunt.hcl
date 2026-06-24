include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-vpn"
}

dependency "vpc" {
  config_path = "../aws-service-vpc"
  mock_outputs = {
    vpc_id = "vpc-0a1b2c3d4e5f67890"
    cgw_id = "cgw-0a1b2c3d4e5f67890"
    vgw_id = "vgw-0a1b2c3d4e5f67890"
  }
}

inputs = {
  cgw_id                   = dependency.vpc.outputs.cgw_id
  remote_ipv4_network_cidr = "#{aws_vpc_cidr_block}#"
  local_ipv4_network_cidr  = "172.17.0.0/16"
  vpn_name                 = "VPN-UX-MDE"
  vgw_id                   = dependency.vpc.outputs.vgw_id
  static_routes            = ["#{aws_vpc_cidr_block}#", "172.17.0.0/16"]
}

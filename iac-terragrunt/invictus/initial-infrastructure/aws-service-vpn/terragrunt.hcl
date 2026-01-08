include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-vpn"
}

dependency "vpc"            {
  config_path               = "../../initial-infrastructure/aws-service-vpc"
  mock_outputs              = {
    vpc_id                  = ["mock_vpc_id"]
    cgw_id                  = ["mock_cgw_id"]
    vgw_id                  = ["mock_vgw_id"]
  }
}

inputs = {
  cgw_id                    = dependency.vpc.outputs.cgw_id
  remote_ipv4_network_cidr  = "#{aws_vpc_cidr_block}#"
  local_ipv4_network_cidr   = "172.17.0.0/16"
  vpn_name                  = "VPN-UX-MDE"
  vgw_id                    = dependency.vpc.outputs.vgw_id
  static_routes             = ["#{aws_vpc_cidr_block}#", "172.17.0.0/16"]
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-vpc"
}

inputs = {
  vpc_cidr_block              = "#{aws_vpc_cidr_block}#"
  vpc_name                    = "#{aws_vpc_name}#"
  cidr_block_gw_local_public  = "#{aws_vpc_cidr_block}#"
  cidr_block_gw_vgw_public    = "172.17.0.0/16"
  cidr_block_gw_local_private = "#{aws_vpc_cidr_block}#"
  cidr_block_gw_vgw_private   = "172.17.0.0/16"
  transit_gateway_id          = "tgw-0f6549bf29da41b08"

  # Subnets públicas
  public_subnets              = {                    
    "subnet1a"                = {
      cidr_block              = "#{aws_public_subnet1a}#"          
      az                      = "us-east-1a"
    }
    "subnet1b"                = {
      cidr_block              = "#{aws_public_subnet1b}#"        
      az                      = "us-east-1b"
    }
  }

  # Subnets privadas
  private_subnets             = {
    "subnet1a"                = {
      cidr_block              = "#{aws_private_subnet1a}#"          
      az                      = "us-east-1a"
    }
    "subnet1b"                = {
      cidr_block              = "#{aws_private_subnet1b}#"          
      az                      = "us-east-1b"
    }
    "subnet1c"                = {
      cidr_block              = "#{aws_private_subnet1c}#"          
      az                      = "us-east-1c"
    }
  }

  # Reglas NACLs para subnets públicas
  public_nacl_rules           = {
    "allow_all_inbound"       = {
      rule_number             = 100
      egress                  = false
      protocol                = "-1"
      cidr_block              = "0.0.0.0/0"
      rule_action             = "allow"
      from_port               = 0
      to_port                 = 0
    },
    "deny_all_inbound"        = {
      rule_number             = 100
      egress                  = true
      protocol                = "-1"
      cidr_block              = "0.0.0.0/0"
      rule_action             = "allow"
      from_port               = 0
      to_port                 = 0
    }
  }

  # Reglas NACLs para subnets privadas
  private_nacl_rules          = {
    "allow_all_inbound"       = {
      rule_number             = 100
      egress                  = false
      protocol                = "-1"
      cidr_block              = "0.0.0.0/0"
      rule_action             = "allow"
      from_port               = 0
      to_port                 = 0
    },
    "allow_all_outbound"      = {
      rule_number             = 100
      egress                  = true
      protocol                = "-1"
      cidr_block              = "0.0.0.0/0"
      rule_action             = "allow"
      from_port               = 0
      to_port                 = 0
    },
  }
}

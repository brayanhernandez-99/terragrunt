include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-cloudmap"
}

dependency "vpc" {
  config_path = "../aws-service-vpc"
  mock_outputs = {
    vpc_id = "vpc-0a1b2c3d4e5f67890"
  }
}

inputs = {
  name        = "invictus.local"
  vpc_id      = dependency.vpc.outputs.vpc_id
  description = "Namespace utilizado por los servicios ECS de Invictus para habilitar el service discovery y la comunicación interna entre contenedores."
}

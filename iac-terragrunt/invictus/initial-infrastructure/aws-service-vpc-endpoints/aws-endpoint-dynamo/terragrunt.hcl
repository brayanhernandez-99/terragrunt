include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-vpc-endpoints-gateway"
}

dependency "vpc"            {
  config_path               = "../../../initial-infrastructure/aws-service-vpc"
  mock_outputs              = {
    private_route_table_id  = "mock_private_route_table_id"
  }
}

inputs = {
  vpc_id                    = dependency.vpc.outputs.vpc_id
  service_name              = "com.amazonaws.us-east-1.dynamodb"
  route_table_id            = [dependency.vpc.outputs.private_route_table_id]
  name_endpoint             = "dynamo-invictus"
}
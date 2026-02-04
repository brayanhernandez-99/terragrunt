include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-vpc-endpoints-gateway"
}

dependency "vpc" {
  config_path = "../../aws-service-vpc"
  mock_outputs = {
    vpc_id             = "mock_vpc_id"
    private_subnet_ids = ["mock_private_subnet_ids"]
  }
}

inputs = {
  vpc_id         = dependency.vpc.outputs.vpc_id
  service_name   = "com.amazonaws.us-east-1.dynamodb"
  route_table_id = [dependency.vpc.outputs.private_route_table_id]
  name_endpoint  = "dynamo-invictus"
}
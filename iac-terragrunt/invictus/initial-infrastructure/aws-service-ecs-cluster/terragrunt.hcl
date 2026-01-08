include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ecs-cluster"
}

inputs = {
  cluster_name  = "invictus"
}

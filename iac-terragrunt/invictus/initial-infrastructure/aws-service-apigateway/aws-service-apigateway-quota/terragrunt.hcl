include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-quota"
}

inputs = {
  service_code = "apigateway"
  quota_code   = "L-E5AE38E3"
  quota_value  = 120000
}

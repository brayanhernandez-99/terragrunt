include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-dynamodb"
}

inputs = {
  name_table_dynamo   = "master-export-file"
  attribute_name      = "id"
  attribute_type      = "S"
  dynamodb_items_json = [
    for item in jsondecode(
      file("${get_terragrunt_dir()}/parameters/master-export-file.json")
    ) : jsonencode(item)
  ]
}
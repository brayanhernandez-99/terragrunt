include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-dynamodb"
}

inputs = {
  name_table_dynamo     = "resources-administration"
  attribute_name        = "id"
  attribute_type        = "S"
  dynamodb_insert_items = true
  dynamodb_items_json = [
    for item in jsondecode(
      file("${get_terragrunt_dir()}/parameters/resources-administration.json")
    ) : jsonencode(item)
  ]
}
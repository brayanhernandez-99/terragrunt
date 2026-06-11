include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-dynamodb"
}

inputs = {
  name_table_dynamo     = "sessions-by-user"
  attribute_name        = "userId"
  attribute_type        = "S"
  dynamodb_insert_items = false
  use_sort_key          = true
  sort_key_name         = "sessionId"
  sort_key_type         = "S"
  dynamodb_items_json = [
    for item in jsondecode(
      file("${get_terragrunt_dir()}/parameters/sessions-by-user.json")
    ) : jsonencode(item)
  ]
}
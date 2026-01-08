include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-dynamodb"
}

inputs = {
  name_table_dynamo     = "file_logs"
  attribute_name        = "service_name"
  attribute_type        = "S"
  dynamodb_insert_items = false
  use_sort_key          = true
  sort_key_name         = "create_at"
  sort_key_type         = "S"
  dynamodb_items_json   = [
    for item in jsondecode(
      file("${get_terragrunt_dir()}/parameters/file_logs.json")
    ) : jsonencode(item)
  ]
}
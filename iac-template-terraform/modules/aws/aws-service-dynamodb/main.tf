resource "aws_dynamodb_table" "dynamodb-table" {
  name                        = var.name_table_dynamo
  hash_key                    = var.attribute_name
  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = true

  attribute {
    name = var.attribute_name
    type = var.attribute_type
  }

  dynamic "attribute" {
    for_each = var.use_sort_key ? [1] : []
    content {
      name = var.sort_key_name
      type = var.sort_key_type
    }
  }
  range_key = var.use_sort_key ? var.sort_key_name : null
}

resource "aws_dynamodb_table_item" "example_item" {
  count      = var.dynamodb_insert_items ? length(var.dynamodb_items_json) : 0
  table_name = aws_dynamodb_table.dynamodb-table.name
  hash_key   = var.attribute_name
  item       = var.dynamodb_items_json[count.index]
}

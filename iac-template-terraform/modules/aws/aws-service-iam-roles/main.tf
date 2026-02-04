resource "aws_iam_role" "iam_role" {
  name = var.iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
          AWS     = "arn:aws:iam::861262569826:root"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy" {
  # for_each           = var.iam_policies_map
  for_each = { for k, v in var.iam_policies_map : k => v if v.policy_json != null }
  name     = each.value.use_suffix ? "${each.value.name}-ms-policy-${random_id.random_suffix.hex}" : each.value.name
  policy   = each.value.policy_json
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  for_each   = aws_iam_policy.iam_policy
  role       = aws_iam_role.iam_role.name
  policy_arn = each.value.arn
}

resource "aws_iam_role_policy_attachment" "aws_managed_policies" {
  for_each   = { for k, v in var.iam_policies_map : k => v if v.managed_arn != null }
  role       = aws_iam_role.iam_role.name
  policy_arn = each.value.managed_arn
}

resource "random_id" "random_suffix" {
  byte_length = 4
}

resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = jsonencode(var.assume_role_policy)
}

resource "aws_iam_role_policy" "policy" {
  count = var.policy != null ? 1 : 0

  name   = var.role_name
  role   = aws_iam_role.role.id
  policy = jsonencode(var.policy)
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(
    var.managed_policy_arns != null ? var.managed_policy_arns : []
  )

  role       = aws_iam_role.role.name
  policy_arn = each.value
}

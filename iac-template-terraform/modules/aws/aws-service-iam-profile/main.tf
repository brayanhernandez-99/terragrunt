resource "aws_iam_role" "iam_role" {
  name = "${var.iam_role_name}-ms-task-definition-${random_id.random_suffix.hex}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy" {
  for_each = var.iam_policies_map
  name     = "${each.value.name}-ms-policy-${random_id.random_suffix.hex}"
  policy   = each.value.policy_json
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  for_each   = aws_iam_policy.iam_policy
  role       = aws_iam_role.iam_role.name
  policy_arn = each.value.arn
}

resource "random_id" "random_suffix" {
  byte_length = 4 # Genera un hexadecimal de 8 caracteres (4 bytes)
}

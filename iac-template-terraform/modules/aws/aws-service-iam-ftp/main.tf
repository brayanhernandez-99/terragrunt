resource "aws_iam_policy" "ec2_s3_policy" {
  name = var.iam_policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "${var.s3_bucket_arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = var.s3_bucket_arn
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssm:DescribeInstanceProperties",
          "ssm:DescribeInstanceInformation",
          "ssm:GetCommandInvocation",
          "ssm:ListCommands",
          "ssm:ListCommandInvocations",
          "ssmmessages:*",
          "ec2messages:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_s3_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}

resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "${var.iam_role_name}-instance-profile"
  role = aws_iam_role.ec2_s3_role.name
}

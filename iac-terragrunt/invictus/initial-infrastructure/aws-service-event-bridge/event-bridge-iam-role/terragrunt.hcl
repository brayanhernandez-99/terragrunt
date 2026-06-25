include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-iam-role"
}

inputs = {
  role_name = "SchedulerTask"

  assume_role_policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "events.amazonaws.com",
            "scheduler.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  }

  policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SendMessagesToSQS"
        Effect = "Allow"
        Action = [
          "sqs:SendMessage"
        ]
        Resource = "arn:aws:sqs:#{aws_region}#:${get_aws_account_id()}:*"
      },
      {
        Sid    = "EventBridgeSchedulerPermissions"
        Effect = "Allow"
        Action = [
          "scheduler:*",
          "iam:PassRole",
          "iam:GetRole",
          "iam:CreateRole",
          "iam:PutRolePolicy",
          "iam:AttachRolePolicy",
          "iam:UpdateAssumeRolePolicy",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  }
}

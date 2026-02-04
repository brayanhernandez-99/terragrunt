include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-iam-roles-eventbridge"
}

inputs = {
  eventbridge_scheduler_policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:*",
          "kms:*",
          "iam:*",
          "scheduler:*"
        ]
        Resource = "*"
      }
    ]
  }
}
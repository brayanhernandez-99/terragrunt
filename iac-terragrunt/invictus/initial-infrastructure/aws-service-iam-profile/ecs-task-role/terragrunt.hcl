include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-iam-profile"
}

inputs = {
  iam_role_name = "ecs-task-role"
  iam_policies_map = {
    policy1 = {
      name = "ecs-task-policy-all"
      policy_json = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Action" : [
              "dynamodb:*",
              "ecr:*",
              "iam:PassRole",
              "kinesis:*",
              "kms:*",
              "s3:*",
              "scheduler:*",
              "secretsmanager:*",
              "sqs:*",
              "ssm:*",
              "cognito-idp:*",
              "xray:*",
              "sns:*"
            ],
            "Resource" : "*",
            "Effect" : "Allow"
          }
        ]
      })
    },
  }
}

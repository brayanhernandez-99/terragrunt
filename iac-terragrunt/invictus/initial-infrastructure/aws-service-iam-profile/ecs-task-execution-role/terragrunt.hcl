include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-iam-profile"
}

inputs = {
  iam_role_name     = "ecs-task-execution-role"
  iam_policies_map  = {
    policy1         = {
      name          = "ecs-task-policy"
      policy_json   = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Action": [
              "ecr:BatchCheckLayerAvailability",
              "ecr:BatchGetImage",
              "ecr:GetDownloadUrlForLayer"
            ],
            "Resource": "arn:aws:ecr:us-east-1:861262569826:repository/*",
            "Effect"  : "Allow"
          },
          {
            "Action"  : "ecr:GetAuthorizationToken",
            "Resource": "*",
            "Effect"  : "Allow"
          },
          {
            "Action"  : [
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": "*",
            "Effect": "Allow"
          },
          {
            Action = [
              "secretsmanager:GetSecretValue",
              "secretsmanager:DescribeSecret"
            ]
            Resource = "*"
            Effect   = "Allow"
          },
          {
            Action = [
              "kms:Decrypt"
            ]
            Resource = "*"
            Effect   = "Allow"
          }
        ]
      })
    }
  }
}

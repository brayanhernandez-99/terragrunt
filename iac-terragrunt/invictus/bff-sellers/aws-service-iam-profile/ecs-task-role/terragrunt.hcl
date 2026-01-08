include "root" {
  path    = find_in_parent_folders("root.hcl")
}

terraform {
  source  = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-iam-profile"
}

inputs = {
  iam_role_name = "ecs-task-role"
  iam_policies_map = {
    policy1 = {
      name        = "ecs-task-policy-all"
      policy_json = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Action": [
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
              "iot:*",
              "xray:*",
              "sns:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
          }
        ]
      })
    },
    # policy2 = {
    #   name        = "taskdefinition"
    #   policy_json = jsonencode({
    #     "Version": "2012-10-17",
    #     "Statement": [
    #       {
    #         "Action": [
    #           "ecr:BatchCheckLayerAvailability",
    #           "ecr:BatchGetImage",
    #           "ecr:GetDownloadUrlForLayer"
    #         ],
    #         "Resource": "arn:aws:ecr:us-east-1:861262569826:repository/microservice-lotteries-develop",
    #         "Effect": "Allow"
    #       },
    #       {
    #         "Action": "ecr:GetAuthorizationToken",
    #         "Resource": "*",
    #         "Effect": "Allow"
    #       },
    #       {
    #         "Action": [
    #           "kms:Decrypt",
    #           "kms:Encrypt",
    #           "kms:GenerateDataKey*",
    #           "kms:ReEncrypt*"
    #         ],
    #         "Resource": "arn:aws:kms:us-east-1:464783675999:key/9f14efd9-1d68-4fe6-a2fd-9583301d5dc2",
    #         "Effect": "Allow"
    #       },
    #       {
    #         "Action": [
    #           "kinesis:DescribeStream",
    #           "kinesis:DescribeStreamConsumer",
    #           "kinesis:DescribeStreamSummary",
    #           "kinesis:GetRecords",
    #           "kinesis:GetShardIterator",
    #           "kinesis:ListShards",
    #           "kinesis:ListStreams",
    #           "kinesis:PutRecord",
    #           "kinesis:PutRecords",
    #           "kinesis:SubscribeToShard"
    #         ],
    #         "Resource": "arn:aws:kinesis:us-east-1:464783675999:stream/Lotteries",
    #         "Effect": "Allow"
    #       },
    #       {
    #         "Action": [
    #           "sqs:ChangeMessageVisibility",
    #           "sqs:DeleteMessage",
    #           "sqs:GetQueueAttributes",
    #           "sqs:GetQueueUrl",
    #           "sqs:ReceiveMessage",
    #           "sqs:SendMessage"
    #         ],
    #         "Resource": "arn:aws:sqs:us-east-1:464783675999:Lotteries",
    #         "Effect": "Allow"
    #       },
    #       {
    #         "Action": [
    #           "ssm:DescribeParameters",
    #           "ssm:GetParameter",
    #           "ssm:GetParameterHistory",
    #           "ssm:GetParameters"
    #         ],
    #         "Resource": [
    #           "arn:aws:ssm:us-east-1:464783675999:parameter/LOTTERIES/DB_SECRET",
    #           "arn:aws:ssm:us-east-1:464783675999:parameter/LOTTERIES/KINESIS_LIMIT",
    #           "arn:aws:ssm:us-east-1:464783675999:parameter/LOTTERIES/KINESIS_POLL_DELAY",
    #           "arn:aws:ssm:us-east-1:464783675999:parameter/LOTTERIES/LOGLEVEL"
    #         ],
    #         "Effect": "Allow"
    #       }
    #     ]
    #   })
    # },
    # policy3 = {
    #   name        = "microservice"
    #   policy_json = jsonencode({
    #     "Version": "2012-10-17",
    #     "Statement": [
    #       {
    #         "Action": [
    #           "dynamodb:*",
    #           "iam:PassRole",
    #           "kinesis:*",
    #           "kms:*",
    #           "s3:*",
    #           "scheduler:*",
    #           "secretsmanager:*",
    #           "sqs:*",
    #           "ssm:*",
    #           "xray:*"
    #         ],
    #         "Resource": "*",
    #         "Effect": "Allow"
    #       }
    #     ]
    #   })
    # }
  }
}
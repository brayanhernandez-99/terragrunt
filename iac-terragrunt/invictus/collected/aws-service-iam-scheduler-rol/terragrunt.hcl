include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source  = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-iam-scheduler"
}

inputs = {
  iam_role_name = "${local.service}-eventbridge-scheduler-role"
  iam_policies_map = {
    policy1 = {
      name        = "${local.service}-eventbridge-scheduler-policy"
      policy_json = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Action": [
              "kinesis:*",
              "kms:*",
              "scheduler:*",
              "iam:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
          }
        ]
      })
    },
  }
}
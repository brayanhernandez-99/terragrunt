include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-event-bridge-rules"
}

dependency "iam_role" {
  config_path = "../event-bridge-role"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/mock-role"
  }
}

inputs = {
  rule_name      = "synchronize-parameters"
  description    = "Rule para enviar eventos a Parameter Store"
  iam_role_arn   = dependency.iam_role.outputs.iam_role_arn
  aws_account_id = "${get_aws_account_id()}"
  target_id      = "Notifier"
  event_pattern = {
    detail-type = ["Parameter Store Change"]
    source      = ["aws.ssm"]
    detail = {
      name = [
        {
          prefix = "/"
        }
      ]
      operation = ["Update"]
    }
  }

  input_paths = {
    detail-name = "$.detail.name"
  }

  input_template = <<EOF
  {
    "topic": "sync-parameters",
    "event": "appNotification",
    "data": {
      "name": <detail-name>
    }
  }
  EOF
}
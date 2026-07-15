include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = basename(dirname(get_terragrunt_dir()))
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-event-bridge-rules"
}

dependency "sqs" {
  config_path = "../../../notifier/aws-service-sqs"
  mock_outputs = {
    queue_arn = "arn:aws:sqs:us-east-1:123456789012:queue"
  }
}

dependency "iam_role" {
  config_path = "../event-bridge-iam-role"
  mock_outputs = {
    role_arn = "arn:aws:iam::123456789012:role/role"
  }
}

inputs = {
  rule_name   = "parameter-store-rule"
  description = "Regla de EventBridge para sincronización de parámetros en Parameter Store"
  target_id   = "send-to-sqs"
  target_arn  = dependency.sqs.outputs.queue_arn
  role_arn    = dependency.iam_role.outputs.role_arn

  event_pattern = {
    source      = ["aws.ssm"]
    detail-type = ["Parameter Store Change"]
    detail = {
      operation = ["Create", "Update", "Delete"]
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
      "name": "<detail-name>"
    }
  }
  EOF
}

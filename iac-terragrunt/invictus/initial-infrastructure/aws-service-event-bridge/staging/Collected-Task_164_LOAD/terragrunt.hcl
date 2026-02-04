include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-event-bridge-scheduler"
}

dependency "kms" {
  config_path = "../../../aws-service-kinesis-ckm"
  mock_outputs = {
    kms_key_arn = "mock_kms_key_arn"
  }
}

dependency "iam_role" {
  config_path = "../../event-bridge-role"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/mock-role"
  }
}

inputs = {
  scheduler_name      = "5cd41b6c-aad6-4a36-96e6-6a9835d93da7-Collected-Task_164_LOAD"
  aws_account_id      = "${get_aws_account_id()}"
  description         = "Tarea automática 164 LOAD"
  iam_role_arn        = dependency.iam_role.outputs.iam_role_arn
  kinesis_name        = "Collected"
  schedule_expression = "cron(*/0 22-23/1 * * ? *)"
  payload = {
    model = {
      idConfiguration = 164
      type            = "LOAD"
    }
    event = "automaticTask"
  }
  kms_key_arn = dependency.kms.outputs.kms_key_arn
}
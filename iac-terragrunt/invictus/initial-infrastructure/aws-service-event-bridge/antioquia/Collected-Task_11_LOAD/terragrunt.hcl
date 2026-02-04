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
  scheduler_name      = "dc7a3bfc-8691-482e-9765-4b7c81fae4a5-Collected-Task_11_LOAD"
  aws_account_id      = "${get_aws_account_id()}"
  description         = "Tarea automática 11 LOAD"
  iam_role_arn        = dependency.iam_role.outputs.iam_role_arn
  kinesis_name        = "Collected"
  schedule_expression = "cron(*/0 0-0/1 * * ? *)"
  payload = {
    model = {
      idConfiguration = 11
      type            = "LOAD"
    }
    event = "automaticTask"
  }
  kms_key_arn = dependency.kms.outputs.kms_key_arn
}
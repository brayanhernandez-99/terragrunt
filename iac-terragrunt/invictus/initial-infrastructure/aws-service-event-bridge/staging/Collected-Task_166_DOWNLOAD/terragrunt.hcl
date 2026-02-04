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
  scheduler_name      = "d497b451-b99c-4276-8067-199d366056f3-Collected-Task_166_DOWNLOAD"
  aws_account_id      = "${get_aws_account_id()}"
  description         = "Tarea automática 166 DOWNLOAD"
  iam_role_arn        = dependency.iam_role.outputs.iam_role_arn
  kinesis_name        = "Collected"
  schedule_expression = "cron(*/10 8-15/1 * * ? *)"
  payload = {
    model = {
      idConfiguration = 166
      type            = "DOWNLOAD"
    }
    event = "automaticTask"
  }
  kms_key_arn = dependency.kms.outputs.kms_key_arn
}
include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = basename(dirname(get_terragrunt_dir()))
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-event-bridge-scheduler"
}

dependency "kms" {
  config_path = "../../../aws-service-kinesis-cmk"
  mock_outputs = {
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/kms-key"
  }
}

dependency "iam_role" {
  config_path = "../../event-bridge-iam-role"
  mock_outputs = {
    role_arn = "arn:aws:iam::123456789012:role/role"
  }
}

inputs = {
  region              = "#{aws_region}#"
  scheduler_name      = "9e5c2720-e4fc-4cfe-be94-08d7528d0d6b-Collected-Task_166_LOAD"
  aws_account_id      = "${get_aws_account_id()}"
  description         = "Tarea automática 166 LOAD"
  iam_role_arn        = dependency.iam_role.outputs.role_arn
  kinesis_name        = "Collected"
  schedule_expression = "cron(*/10 8-16/1 * * ? *)"
  payload = {
    model = {
      idConfiguration = 166
      type            = "LOAD"
    }
    event = "automaticTask"
  }
  kms_key_arn = dependency.kms.outputs.kms_key_arn
}

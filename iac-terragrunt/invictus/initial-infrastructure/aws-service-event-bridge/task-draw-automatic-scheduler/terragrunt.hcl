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
  config_path = "../../aws-service-kinesis-ckm"
  mock_outputs = {
    kms_key_arn = "mock_kms_key_arn"
  }
}

dependency "iam_role" {
  config_path = "../event-bridge-role"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/mock-role"
  }
}

inputs = {
  scheduler_name        = "LotteriesGames-taskdrawautomatic"
  aws_account_id        = "${get_aws_account_id()}"
  description           = "Tarea automática sorteo automático"
  iam_role_arn          = dependency.iam_role.outputs.iam_role_arn
  kinesis_partition_key = "sha-000000000000000001"
  kinesis_name          = "LotteriesGames"
  schedule_expression   = "cron(59 23 * * ? *)"
  payload               = jsonencode(jsondecode(file("./parameters/#{parameter_payload}#")))
  kms_key_arn           = dependency.kms.outputs.kms_key_arn
}
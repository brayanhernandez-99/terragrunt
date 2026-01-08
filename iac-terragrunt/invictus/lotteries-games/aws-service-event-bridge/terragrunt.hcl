include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-event-bridge"
}

dependency "kms" {
  config_path         = "../../initial-infrastructure/aws-service-kinesis-ckm"
  mock_outputs        = {
    kms_key_arn       = "mock_kms_key_arn"
  }
}

inputs = {
  scheduler_name      = "LotteriesGames-taskdrawautomatic"
  aws_account_id      = "${get_aws_account_id()}"
  kinesis_name        = "LotteriesGames"
  schedule_expression = "cron(59 23 * * ? *)"
  payload             = jsonencode(jsondecode(file("./parameters/#{parameter_payload}#")))
  kms_key_arn         = dependency.kms.outputs.kms_key_arn
}
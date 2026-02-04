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
  scheduler_name      = "0e841816-b701-4e41-8129-0c276afa6851-Payments-CLOSURE-1"
  aws_account_id      = "${get_aws_account_id()}"
  description         = "Cierre empresa 1"
  iam_role_arn        = dependency.iam_role.outputs.iam_role_arn
  kinesis_name        = "Payments"
  schedule_expression = "cron(01 00 * * ? *)"
  payload = {
    model = {
      idConfiguration = 1
      type            = "CLOSURE_TASK"
      event           = "companyClosureOrchestration"
    }
    event = "companyClosureOrchestration"
  }
  kms_key_arn = dependency.kms.outputs.kms_key_arn
}
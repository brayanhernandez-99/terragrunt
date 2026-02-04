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
  scheduler_name      = "6122e0f0-7509-42ac-9c59-db454f15a549-Conciliation-taskbackupauto"
  aws_account_id      = "${get_aws_account_id()}"
  description         = "Tarea automática iniciar backup"
  iam_role_arn        = dependency.iam_role.outputs.iam_role_arn
  kinesis_name        = "Conciliation"
  schedule_expression = "cron(46 18 8 1 ? 2026)"
  payload = {
    model = {
      idSalesSecurityBackup = 2
      mode                  = "PARTIAL-AUTO"
      taskId                = "6122e0f0-7509-42ac-9c59-db454f15a549-Conciliation-taskbackupauto"
      subcategories         = [6, 7]
      time                  = "18:45:00"
    }
    event = "startBackupAutomaticTask"
  }
  kms_key_arn = dependency.kms.outputs.kms_key_arn
}
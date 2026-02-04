include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-sqs-dlq"
}

dependency "sqs_dlq" {
  config_path = "../aws-service-sqs-dlq"
  mock_outputs = {
    queue_arn = "mock_queue_arn"
  }
}

inputs = {
  queue_name                  = "${title(local.service)}"
  visibility_timeout_seconds  = 30 #30 segundos
  message_retention_seconds   = 345600
  max_message_size            = 1048576 # Tamaño máximo de mensaje en bytes (1024 KB)
  delay_seconds               = 0
  receive_wait_time_seconds   = 0
  fifo_queue                  = false
  content_based_deduplication = false
  dlq_arn                     = dependency.sqs_dlq.outputs.queue_arn
  maxReceiveCount             = 1
  kms_master_key_id           = "#{aws_kms_master_key_id}#" #varia segun el ambiente (SQS/Encryption/CMK alias)
}
resource "aws_sqs_queue" "aws_queue" {
  name                      = var.queue_name
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  delay_seconds              = var.delay_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  # Configuración para colas FIFO (opcional)
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  kms_master_key_id           = var.kms_master_key_id
}
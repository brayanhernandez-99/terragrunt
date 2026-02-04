variable "queue_name" {
  description = "Nombre de la cola SQS"
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "Tiempo en segundos que el mensaje permanecerá invisible después de ser leído por un consumidor"
  type        = number
}

variable "message_retention_seconds" {
  description = "Tiempo en segundos que el mensaje se conservará en la cola"
  type        = number
}

variable "delay_seconds" {
  description = "Tiempo en segundos que un mensaje debe retrasarse antes de ser entregado"
  type        = number
}

variable "receive_wait_time_seconds" {
  description = "Tiempo de espera para la recuperación de mensajes en segundos"
  type        = number
}

variable "fifo_queue" {
  description = "Indica si la cola es FIFO (First-In-First-Out)"
  type        = bool
}

variable "content_based_deduplication" {
  description = "Activar la deduplicación basada en el contenido del mensaje"
  type        = bool
}

variable "dlq_arn" {
  description = "Nombre de la cola SQS"
  type        = string
}

variable "maxReceiveCount" {
  description = "Numero encolamiento de mensajes"
  type        = number
}

variable "kms_master_key_id" {
  description = "arn del master key"
  type        = string
}

variable "max_message_size" {
  description = "Tamaño máximo de mensaje en bytes"
  type        = number
}
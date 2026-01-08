variable "stream_name" {
  description = "Nombre del stream de Kinesis Data"
  type        = string
}

variable "shard_count" {
  description = "Número de shards para el stream"
  type        = number
}

variable "retention_period" {
  description = "Periodo de retención de datos en el stream (mínimo 24 horas, máximo 168 horas)"
  type        = number
}


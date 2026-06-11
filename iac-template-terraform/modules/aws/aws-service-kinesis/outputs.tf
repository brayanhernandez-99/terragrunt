output "kinesis_stream_arn" {
  description = "El ARN del Kinesis Data Stream creado"
  value       = aws_kinesis_stream.kinesis_stream.arn
}

output "kinesis_stream_name" {
  description = "Nombre del Kinesis Data Stream"
  value       = aws_kinesis_stream.kinesis_stream.name
}

output "kinesis_stream_shards" {
  description = "Número de shards en el Kinesis Data Stream"
  value       = aws_kinesis_stream.kinesis_stream.shard_count
}


output "queue_name" {
  description = "Nombre de la cola SQS creada"
  value       = aws_sqs_queue.aws_queue.name
}

output "queue_url" {
  description = "URL de la cola SQS creada"
  value       = aws_sqs_queue.aws_queue.id
}

output "queue_arn" {
  description = "ARN de la cola SQS creada"
  value       = aws_sqs_queue.aws_queue.arn
}

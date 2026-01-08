resource "aws_kinesis_stream" "kinesis_stream" {
  name             = var.stream_name
  shard_count      = var.shard_count
  retention_period = var.retention_period
}

resource "aws_kinesis_stream_consumer" "kinesis_consumer" {
  stream_arn    = aws_kinesis_stream.kinesis_stream.arn
  name          = "${var.stream_name}-consumer"
  depends_on = [aws_kinesis_stream.kinesis_stream]
}

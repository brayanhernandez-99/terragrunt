resource "aws_cloudfront_function" "function" {
  name    = var.name_function
  runtime = var.runtime_function
  #publish  = true
  code = var.code_function
}
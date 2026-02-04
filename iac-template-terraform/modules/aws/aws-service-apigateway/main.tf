resource "aws_api_gateway_rest_api" "administration_api" {
  name        = var.api_name
  description = "API Gateway REST conectado a un NLB"
  endpoint_configuration {
    types = [var.api_endpoint_type]
  }
}

resource "aws_api_gateway_method" "root_any" {
  rest_api_id   = aws_api_gateway_rest_api.administration_api.id
  resource_id   = aws_api_gateway_rest_api.administration_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.administration_api.id
  parent_id   = aws_api_gateway_rest_api.administration_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.administration_api.id
  resource_id   = aws_api_gateway_resource.proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method" "proxy_options" {
  rest_api_id   = aws_api_gateway_rest_api.administration_api.id
  resource_id   = aws_api_gateway_resource.proxy_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "root_any_integration" {
  rest_api_id = aws_api_gateway_rest_api.administration_api.id
  resource_id = aws_api_gateway_rest_api.administration_api.root_resource_id
  http_method = aws_api_gateway_method.root_any.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "any_root_integrate_response" {
  rest_api_id = aws_api_gateway_rest_api.administration_api.id
  resource_id = aws_api_gateway_rest_api.administration_api.root_resource_id
  http_method = aws_api_gateway_method.proxy_any.http_method
  status_code = "200"

  response_templates = {
    "application/json" = ""
  }

}

resource "aws_api_gateway_method_response" "any_root_method_response" {
  rest_api_id = aws_api_gateway_rest_api.administration_api.id
  resource_id = aws_api_gateway_rest_api.administration_api.root_resource_id
  http_method = aws_api_gateway_method.proxy_any.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "proxy_any_integration" {
  rest_api_id             = aws_api_gateway_rest_api.administration_api.id
  resource_id             = aws_api_gateway_resource.proxy_resource.id
  http_method             = aws_api_gateway_method.proxy_any.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link

  uri = "http://${var.nlb_dns_name}:8082/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_method_response" "proxy_options_response" {
  rest_api_id = aws_api_gateway_rest_api.administration_api.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = aws_api_gateway_method.proxy_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Credentials" = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Origin"      = true

  }
}

resource "aws_api_gateway_integration" "proxy_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.administration_api.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = aws_api_gateway_method.proxy_options.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "proxy_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.administration_api.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = aws_api_gateway_method.proxy_options.http_method
  status_code = aws_api_gateway_method_response.proxy_options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
    "method.response.header.Access-Control-Allow-Headers"     = "'*'"
    "method.response.header.Access-Control-Allow-Methods"     = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
  }
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_deployment" "deployment_api" {
  depends_on = [
    aws_api_gateway_integration.proxy_any_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.administration_api.id
}




### Nuevo, para provider 6.8.0
resource "aws_cloudwatch_log_group" "api_gw_access_logs" {
  name              = "/aws/apigateway/${var.api_name}/${var.stage_name}"
  retention_in_days = 30
}

resource "aws_api_gateway_stage" "stage" {
  rest_api_id          = aws_api_gateway_rest_api.administration_api.id
  deployment_id        = aws_api_gateway_deployment.deployment_api.id
  stage_name           = var.stage_name
  xray_tracing_enabled = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_access_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      caller         = "$context.identity.caller"
      user           = "$context.identity.user"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }
  tags = {
    Environment = var.stage_name
  }
}

resource "aws_api_gateway_account" "account" {
  cloudwatch_role_arn = aws_iam_role.apigw_cloudwatch_role.arn
}

resource "aws_iam_role" "apigw_cloudwatch_role" {
  name = "apigateway-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "apigateway.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "apigw_cloudwatch_policy" {
  role = aws_iam_role.apigw_cloudwatch_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "${aws_cloudwatch_log_group.api_gw_access_logs.arn}:*"
    }]
  })
}

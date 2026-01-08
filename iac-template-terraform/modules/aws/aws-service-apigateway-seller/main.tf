# resource "aws_api_gateway_vpc_link" "vpc_link" {
#   name = var.vpc_link
#   target_arns = [var.nlb_arn] 
# }

// Crear la API Gateway
resource "aws_api_gateway_rest_api" "administration_api" {
  name = var.api_name
  description = "API Gateway REST conectado a un NLB"
  endpoint_configuration {
    types = [var.api_endpoint_type] // Definir el tipo de endpoint
  }
}


# Metodo ANY INCIAL  /
resource "aws_api_gateway_method" "root_any" {
  rest_api_id   = aws_api_gateway_rest_api.administration_api.id
  resource_id   = aws_api_gateway_rest_api.administration_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

#Recurso proxy+
resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.administration_api.id
  parent_id   = aws_api_gateway_rest_api.administration_api.root_resource_id
  path_part   = "{proxy+}"
}

#Recurso Proxy
#            Any
resource "aws_api_gateway_method" "proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.administration_api.id
  resource_id   = aws_api_gateway_resource.proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"

   request_parameters = {
    "method.request.path.proxy" = true
  }
}

#Recurso Proxy
#            Any
#            OPTIONS
resource "aws_api_gateway_method" "proxy_options" {
  rest_api_id   = aws_api_gateway_rest_api.administration_api.id
  resource_id   = aws_api_gateway_resource.proxy_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}



// Integración con la API (puede ser MOCK, HTTP o AWS_PROXY) - integración /ANY
resource "aws_api_gateway_integration" "root_any_integration" {
  rest_api_id             = aws_api_gateway_rest_api.administration_api.id
  resource_id             = aws_api_gateway_rest_api.administration_api.root_resource_id
  http_method             = aws_api_gateway_method.root_any.http_method
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# resource "aws_api_gateway_integration_response" "any_root_integrate_response" {
#   rest_api_id = aws_api_gateway_rest_api.administration_api.id
#   resource_id = aws_api_gateway_rest_api.administration_api.root_resource_id
#   http_method = aws_api_gateway_method.proxy_any.http_method
#   status_code = "200"
  
#   response_templates = {
#     "application/json" = "" 
#   }
  
# }

# Integración con la API (puede ser MOCK, HTTP o AWS_PROXY) - integración /ANY
#                                                                               proxy+
#                                                                                     ANY
resource "aws_api_gateway_integration" "proxy_any_integration" {
  rest_api_id             = aws_api_gateway_rest_api.administration_api.id
  resource_id             = aws_api_gateway_resource.proxy_resource.id
  http_method             = aws_api_gateway_method.proxy_any.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link

  #  La URI debe incluir {proxy} para que API Gateway pase la ruta al NLB
  uri = "http://${var.nlb_dns_name}:${var.port_cluster}/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}


#Respuesta del metodo OPTIONS
resource "aws_api_gateway_method_response" "proxy_options_response" {
  rest_api_id = aws_api_gateway_rest_api.administration_api.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = aws_api_gateway_method.proxy_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Credentials" = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true

  }
}

#iNTEGRACIÓN DEL METODO OPTIONS
resource "aws_api_gateway_integration" "proxy_options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.administration_api.id
  resource_id             = aws_api_gateway_resource.proxy_resource.id
  http_method             = aws_api_gateway_method.proxy_options.http_method
  type                    = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

#RESPUESTA DE LA INTEGRACIÓN DEL METODO OPTIONS
resource "aws_api_gateway_integration_response" "proxy_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.administration_api.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = aws_api_gateway_method.proxy_options.http_method
  status_code = aws_api_gateway_method_response.proxy_options_response.status_code
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  response_templates = {
    "application/json" = "" 
  }
}


// Crear el deployment de la API Gateway
resource "aws_api_gateway_deployment" "deployment_api" {
  depends_on = [
    aws_api_gateway_integration.proxy_any_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.administration_api.id
  stage_name  = var.stage_name 
}

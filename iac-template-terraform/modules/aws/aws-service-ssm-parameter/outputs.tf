output "ssm_parameters" {
  description = "Lista de los parametros creados en SSM"
  value = {
    for key, param in aws_ssm_parameter.ssm-param-customer:
    key => {
      arn = param.arn
      name = param.name
      type = param.type
      version = param.version
      description = param.description
    }
  }
}
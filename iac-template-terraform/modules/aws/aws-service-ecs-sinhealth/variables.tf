# Variables para el nombre del servicio ECS
variable "name_service" {
  description = "Nombre del servicio ECS"
  type = string
}

# Variables para la creación de tareas ECS
variable "ecs_task" {
  description = "Lista de tareas ECS con sus parámetros."
  type = object({
    cpu                    = string
    memory                 = string
    container_image        = string
    container_port_mappings = list(object({
      containerPort = number
      hostPort      = number
    }))
    environment = list(object({
      name  = string
      value = string
    }))
  })
}

variable "ecs_task_execution_role_arn" {
  description = "ARN del rol de ejecución para la tarea ECS, utilizado para permisos relacionados con la ejecución (por ejemplo, extraer imágenes desde ECR, registrar logs en CloudWatch)."
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ARN del rol asociado a la tarea ECS, utilizado para definir los permisos que las aplicaciones dentro del contenedor pueden necesitar (por ejemplo, acceso a S3, DynamoDB)."
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs de las subnets donde se ejecutarán los servicios ECS"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID del grupo de seguridad a utilizar para los servicios ECS"
  type        = string
  default = ""
}

variable "listener_port" {
  description = "Puerto del listener"
  type        = number
}
# Región de AWS
variable "region" {
  description = "Región de AWS"
  type        = string
  default = "us-east-1"
}

variable "nlb_arn" {
  description = "ARN del Loand Balancer"
  type        = string
}

variable "target_group_config" {
  description = "Configuración del Target Group."
  type = object({
    name               = string
    port               = number
    vpc_id             = string
    health_check_port  = string
    health_check_interval = number
    health_check_timeout  = number
    healthy_threshold     = number
    unhealthy_threshold   = number
  })
}

variable "ecs_cluster_id" {
  description = "ID del cluster ECS"
  type        = string
}

variable "ecs_cluster_name" {
  description = "name del cluster ECS"
  type        = string
}


variable "ecs_service_autoscaling" {
  description = "Configuración de auto scaling para ECS"
  type = object({
    min_capacity      = number
    max_capacity      = number
    cpu_target_value  = number
    memory_target_value = number
  })
}
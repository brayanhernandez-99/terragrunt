# Variables para el nombre del servicio ECS
variable "name_service" {
  description = "Nombre del servicio ECS"
  type        = string
}

# Variables para la creación de tareas ECS
variable "ecs_task" {
  description = "Lista de tareas ECS con sus parámetros."
  type = object({
    cpu    = string
    memory = string
    image  = string
    environment = list(object({
      name  = string
      value = string
    }))
  })
}

# Variables para el rol de ejecución de la tarea ECS
variable "ecs_task_execution_role_arn" {
  description = "ARN del rol de ejecución para la tarea ECS, utilizado para permisos relacionados con la ejecución (por ejemplo, extraer imágenes desde ECR, registrar logs en CloudWatch)."
  type        = string
}

# Variables para el rol de la tarea ECS
variable "ecs_task_role_arn" {
  description = "ARN del rol asociado a la tarea ECS, utilizado para definir los permisos que las aplicaciones dentro del contenedor pueden necesitar (por ejemplo, acceso a S3, DynamoDB)."
  type        = string
}

# Región de AWS
variable "region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

# ID del cluster ECS
variable "ecs_cluster_id" {
  description = "ID del cluster ECS"
  type        = string
}

# Lista de IDs de las subnets donde se ejecutarán los servicios ECS
variable "subnet_ids" {
  description = "Lista de IDs de las subnets donde se ejecutarán los servicios ECS"
  type        = list(string)
}

# ID del grupo de seguridad a utilizar para los servicios ECS
variable "security_group_id" {
  description = "ID del grupo de seguridad a utilizar para los servicios ECS"
  type        = string
  default     = ""
}

variable "ecs_cluster_name" {
  description = "name del cluster ECS"
  type        = string
}

variable "ecs_service_autoscaling" {
  description = "Configuración de auto scaling para ECS"
  type = object({
    min_capacity        = number
    max_capacity        = number
    cpu_target_value    = number
    memory_target_value = number
  })
}
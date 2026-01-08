# Crear definiciones de tareas dinámicas para Fargate
resource "aws_ecs_task_definition" "ecs_task" {
  family                                       = var.name_service
  network_mode                                 = "awsvpc"
  requires_compatibilities                     = ["FARGATE"]
  cpu                                          = var.ecs_task.cpu
  memory                                       = var.ecs_task.memory

  container_definitions                        = jsonencode([
    {
      name                                     = var.name_service
      image                                    = var.ecs_task.container_image
      essential                                = true
      environment                              = [
        for env_var in var.ecs_task.environment: {
          name                                 = env_var.name
          value                                = env_var.value
        }
      ]
      # healthCheck                            = {
      #     command                            = ["CMD-SHELL","curl -f http://localhost/health || exit 1"]
      #     interval                           = 60
      #     timeout                            = 5
      #     retries                            = 3
      # }
      logConfiguration                         = {
        logDriver                              = "awslogs"
        options                                = {
          awslogs-group                        = aws_cloudwatch_log_group.log_group.name
          awslogs-region                       = var.region
          awslogs-stream-prefix                = "aws-ecs"
        }
      }
    }
  ])

  execution_role_arn                           = var.ecs_task_execution_role_arn
  task_role_arn                                = var.ecs_task_role_arn
  lifecycle {
    ignore_changes = [container_definitions]
  }
}

# Crear servicios ECS para Fargate
resource "aws_ecs_service" "ecs_service" {
  name                                         = var.name_service
  cluster                                      = var.ecs_cluster_id
  task_definition                              = aws_ecs_task_definition.ecs_task.arn
  launch_type                                  = "FARGATE"
  desired_count                                = 1

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.security_group_id]
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

# Crear grupo de logs en CloudWatch
resource "aws_cloudwatch_log_group" "log_group" {
  name                                         = "/aws-ecs/${var.name_service}"
  retention_in_days                            = "30"
}

resource "aws_appautoscaling_target" "ecs_service_scaling_target" {
  max_capacity       = var.ecs_service_autoscaling.max_capacity
  min_capacity       = var.ecs_service_autoscaling.min_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${var.name_service}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_cpu_scaling_policy" {
  name               = "${var.name_service}-cpu-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_service_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.ecs_service_autoscaling.cpu_target_value
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "ecs_memory_scaling_policy" {
  name               = "${var.name_service}-memory-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_service_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = var.ecs_service_autoscaling.memory_target_value
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

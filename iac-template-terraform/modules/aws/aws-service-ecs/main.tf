# Crear service discovery interno en el namespace de Cloudmap.
resource "aws_service_discovery_service" "cloudmap_service" {
  name        = var.name_service
  description = "Service discovery interno para microservicios en ECS"

  dns_config {
    namespace_id   = var.cloudmap_namespace_id
    routing_policy = "MULTIVALUE"

    dns_records {
      type = "A"
      ttl  = 15
    }
  }
}

# Crear definiciones de tareas dinámicas para Fargate.
resource "aws_ecs_task_definition" "ecs_task" {
  family                   = var.name_service
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task.cpu
  memory                   = var.ecs_task.memory

  container_definitions = jsonencode([
    {
      name      = var.name_service
      image     = var.ecs_task.image
      essential = true
      portMappings = [
        for mapping in var.ecs_task.portMappings : {
          containerPort = mapping.containerPort
        }
      ]
      environment = [
        for env_var in var.ecs_task.environment : {
          name  = env_var.name
          value = env_var.value
        }
      ]
      secrets = [
        for secret in var.ecs_task.secrets : {
          name      = secret.name
          valueFrom = secret.valueFrom
        }
      ]
      healthCheck = {
        command     = var.ecs_task.health_check.command
        interval    = var.ecs_task.health_check.interval
        timeout     = var.ecs_task.health_check.timeout
        retries     = var.ecs_task.health_check.retries
        startPeriod = var.ecs_task.health_check.startPeriod
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.log_group.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "aws-ecs"
        }
      }
    }
  ])

  execution_role_arn = var.ecs_task_execution_role_arn
  task_role_arn      = var.ecs_task_role_arn

  # lifecycle {
  #   ignore_changes = [container_definitions]
  # }
}

# Crear servicios ECS para Fargate
resource "aws_ecs_service" "ecs_service" {
  name                          = var.name_service
  cluster                       = var.ecs_cluster_id
  task_definition               = aws_ecs_task_definition.ecs_task.arn
  launch_type                   = "FARGATE"
  desired_count                 = 1
  availability_zone_rebalancing = "ENABLED"

  service_registries {
    registry_arn = aws_service_discovery_service.cloudmap_service.arn
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nlb_target_group.arn
    container_name   = var.name_service
    container_port   = var.target_group_config.port
  }

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.security_group_id]
  }

  # lifecycle {
  #   ignore_changes = [task_definition]
  # }
}

# Target Group para el ECS
resource "aws_lb_target_group" "nlb_target_group" {
  name        = "${var.target_group_config.name}-nbl-tg"
  port        = var.target_group_config.port
  protocol    = "TCP"
  vpc_id      = var.target_group_config.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "TCP"
    port                = var.target_group_config.health_check_port
    interval            = var.target_group_config.health_check_interval
    timeout             = var.target_group_config.health_check_timeout
    healthy_threshold   = var.target_group_config.healthy_threshold
    unhealthy_threshold = var.target_group_config.unhealthy_threshold
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = var.nlb_arn
  port              = var.listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group.arn
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws-ecs/${var.name_service}"
  retention_in_days = "30"
}

resource "aws_appautoscaling_target" "ecs_service_scaling_target" {
  max_capacity       = var.ecs_service_autoscaling.max_capacity
  min_capacity       = var.ecs_service_autoscaling.min_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${var.name_service}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.ecs_service]
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

resource "aws_appautoscaling_scheduled_action" "ecs_service_scheduled_action" {
  for_each = var.ecs_service_scheduled_actions

  name               = "${var.name_service}-${each.key}"
  service_namespace  = "ecs"
  timezone           = lookup(each.value, "timezone", null)
  start_time         = lookup(each.value, "start_time", null)
  resource_id        = "service/${var.ecs_cluster_name}/${var.name_service}"
  scalable_dimension = "ecs:service:DesiredCount"
  schedule           = each.value.schedule

  scalable_target_action {
    min_capacity = each.value.min_capacity
    max_capacity = each.value.max_capacity
  }

  depends_on = [aws_appautoscaling_target.ecs_service_scaling_target]
}

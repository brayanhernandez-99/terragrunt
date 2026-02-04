include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ecs"
}

dependency "vpc" {
  config_path = "../../initial-infrastructure/aws-service-vpc"
  mock_outputs = {
    private_subnet_ids    = ["mock_private_subnet_ids"]
    ecs_security_group_id = "mock-sg-1234567890"
  }
}

dependency "cloudmap" {
  config_path = "../../initial-infrastructure/aws-service-cloudmap"
  mock_outputs = {
    cloudmap_namespace_id = "mock-cloudmap-namespace-id"
  }
}

dependency "ecs_cluster" {
  config_path = "../../initial-infrastructure/aws-service-ecs-cluster"
  mock_outputs = {
    ecs_cluster_id = "mock-ecs-cluster-id"
  }
}

dependency "load_balancer" {
  config_path = "../../initial-infrastructure/aws-service-load-balancer"
  mock_outputs = {
    nlb_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/mock-nlb-arn"
  }
}

dependency "task_execution" {
  config_path = "../../initial-infrastructure/aws-service-iam-profile/ecs-task-execution-role"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/mock-iam-role-arn"
  }
}

dependency "task_role" {
  config_path = "../../initial-infrastructure/aws-service-iam-profile/ecs-task-role"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/mock-iam-role-arn"
  }
}

dependency "rds" {
  config_path = "../../initial-infrastructure/aws-service-rds"
  mock_outputs = {
    endpoint = "mock-endpoint"
    port     = "mock-port"
  }
}

dependency "secret_manager" {
  config_path = "../aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mock"
  }
}

inputs = {
  region       = "us-east-1"
  name_service          = "${local.service}"
  cloudmap_namespace_id = dependency.cloudmap.outputs.cloudmap_namespace_id

  ecs_task = {
    cpu    = "1024"
    memory = "2048"
    image  = "861262569826.dkr.ecr.us-east-1.amazonaws.com/microservice-${local.service}-#{aws_container_image}#:latest"
    portMappings = [
      {
        containerPort = 8443
        hostPort      = 8443
      }
    ]
    environment = [
      {
        name  = "CLUSTER_ENDPOINT"
        value = "${dependency.rds.outputs.endpoint}"
      },
      {
        name  = "CLUSTER_PORT"
        value = "${dependency.rds.outputs.port}"
      },
      {
        name  = "ENVIRONMENT"
        value = "#{aws_environment}#"
      },
      {
        name  = "PORT"
        value = "8443"
      },
      {
        name  = "REGION"
        value = "us-east-1"
      }
    ]
    secrets = [
      {
        name      = "TRINO_USER"
        valueFrom = "${dependency.secret_manager.outputs.secret_arn}:user::"
      },
      {
        name      = "TRINO_PASSWORD"
        valueFrom = "${dependency.secret_manager.outputs.secret_arn}:password::"
      },
      {
        name      = "CLUSTER_USER"
        valueFrom = "${dependency.secret_manager.outputs.secret_arn}:clusterUser::"
      },
      {
        name      = "CLUSTER_PASSWORD"
        valueFrom = "${dependency.secret_manager.outputs.secret_arn}:clusterPassword::"
      }
    ]
    health_check = {
      command     = ["CMD-SHELL", "curl -kf https://localhost:8443/v1/info || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 80
    }
  }

  target_group_config = {
    name                  = "${local.service}"
    port                  = 8443
    vpc_id                = dependency.vpc.outputs.vpc_id
    health_check_port     = 8443
    health_check_interval = 30
    health_check_timeout  = 20
    healthy_threshold     = 5
    unhealthy_threshold   = 2
  }

  ecs_cluster_id   = dependency.ecs_cluster.outputs.ecs_cluster_id
  ecs_cluster_name = dependency.ecs_cluster.outputs.ecs_cluster_name
  listener_port    = 8443
  nlb_arn          = dependency.load_balancer.outputs.nlb_arn

  subnet_ids        = dependency.vpc.outputs.private_subnet_ids
  security_group_id = dependency.vpc.outputs.ecs_security_group_id

  ecs_task_execution_role_arn = dependency.task_execution.outputs.iam_role_arn
  ecs_task_role_arn           = dependency.task_role.outputs.iam_role_arn

  ecs_service_autoscaling = {
    min_capacity        = "#{aws_autoscaling_min_capacity_trino}#"
    max_capacity        = "#{aws_autoscaling_max_capacity_trino}#"
    cpu_target_value    = "#{aws_autoscaling_cpu_target_value}#"
    memory_target_value = "#{aws_autoscaling_memory_target_value}#"
  }
}
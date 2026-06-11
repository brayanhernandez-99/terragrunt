include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = basename(dirname(get_terragrunt_dir()))
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
    nlb_arn = "arn:aws:elasticloadbalancing:#{aws_region}#:123456789012:loadbalancer/net/mock-nlb-arn"
  }
}

dependency "task_execution" {
  config_path = "../../initial-infrastructure/aws-service-iam-role/ecs-task-execution-role"
  mock_outputs = {
    role_arn = "arn:aws:iam::123456789012:role/mock-iam-role-arn"
  }
}

dependency "task_role" {
  config_path = "../../initial-infrastructure/aws-service-iam-role/ecs-task-role"
  mock_outputs = {
    role_arn = "arn:aws:iam::123456789012:role/mock-iam-role-arn"
  }
}

dependency "rds" {
  config_path = "../../initial-infrastructure/aws-service-rds/aws-service-rds"
  mock_outputs = {
    username           = "mock-username"
    password           = "mock-password"
    endpoint           = "mock-endpoint"
    port               = "mock-port"
    cluster_identifier = "mock-cluster-identifier"
  }
}

dependency "secret_manager" {
  config_path = "../aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:#{aws_region}#:123456789012:secret:mock"
  }
}

inputs = {
  enable_nlb            = true
  name_service          = "${local.service}"
  cloudmap_namespace_id = dependency.cloudmap.outputs.cloudmap_namespace_id

  subnet_ids        = dependency.vpc.outputs.private_subnet_ids
  security_group_id = dependency.vpc.outputs.ecs_security_group_id

  region                      = "#{aws_region}#"
  ecs_cluster_id              = dependency.ecs_cluster.outputs.ecs_cluster_id
  ecs_cluster_name            = dependency.ecs_cluster.outputs.ecs_cluster_name
  ecs_task_execution_role_arn = dependency.task_execution.outputs.role_arn
  ecs_task_role_arn           = dependency.task_role.outputs.role_arn

  ecs_task = {
    cpu    = "2048"
    memory = "4096"
    image  = "public.ecr.aws/p0a9i7q5/metabase-starburst:latest"
    portMappings = [
      {
        containerPort = 3000
      }
    ]
    environment = [
      {
        name  = "MB_DB_TYPE"
        value = "mysql"
      },
      {
        name  = "MB_DB_DBNAME"
        value = "metabase"
      },
      {
        name  = "ENVIRONMENT"
        value = "#{aws_environment}#"
      },
      {
        name  = "PORT"
        value = "3000"
      },
      {
        name  = "REGION"
        value = "#{aws_region}#"
      }
    ]
    secrets = [
      {
        name      = "MB_DB_HOST"
        valueFrom = "${dependency.secret_manager.outputs.secret_arn}:host::"
      },
      {
        name      = "MB_DB_PORT"
        valueFrom = "${dependency.secret_manager.outputs.secret_arn}:port::"
      },
      {
        name      = "MB_DB_USER"
        valueFrom = "${dependency.secret_manager.outputs.secret_arn}:username::"
      },
      {
        name      = "MB_DB_PASS"
        valueFrom = "${dependency.secret_manager.outputs.secret_arn}:password::"
      }
    ]
    health_check = {
      command     = ["CMD-SHELL", "curl -kf http://localhost:3000/health || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 80
    }
  }

  listener_port = 3000
  nlb_arn       = dependency.load_balancer.outputs.nlb_arn
  target_group_config = {
    name                  = "${local.service}"
    port                  = 3000
    vpc_id                = dependency.vpc.outputs.vpc_id
    health_check_port     = 3000
    health_check_interval = 30
    health_check_timeout  = 20
    healthy_threshold     = 5
    unhealthy_threshold   = 2
  }
}

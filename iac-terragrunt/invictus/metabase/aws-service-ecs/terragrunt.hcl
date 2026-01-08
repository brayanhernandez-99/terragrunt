include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  service = "${basename(dirname(get_terragrunt_dir()))}"
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-ecs-metabase"
}

dependency "vpc" {
  config_path             = "../../initial-infrastructure/aws-service-vpc"
  mock_outputs            = {
    private_subnet_ids    = ["mock_private_subnet_ids"]
    ecs_security_group_id = "mock-sg-1234567890"
    public_subnet_ids     = ["mock_public_subnet_ids"]
  }
}

dependency "ecs_cluster" {
  config_path             = "../../initial-infrastructure/aws-service-ecs-cluster"
  mock_outputs            = {
    ecs_cluster_id        = "mock-ecs-cluster-id"
  }
}

dependency "load_balancer" {
  config_path             = "../../initial-infrastructure/aws-service-load-balancer"
  mock_outputs            = {
    nlb_arn               = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/mock-nlb-arn"
  }
}

dependency "task_execution" {
  config_path             = "../../initial-infrastructure/aws-service-iam-profile/ecs-task-execution-role"
  mock_outputs            = {
    iam_role_arn          = "arn:aws:iam::123456789012:role/mock-iam-role-arn"
  }
}

dependency "task_role" {
  config_path             = "../../initial-infrastructure/aws-service-iam-profile/ecs-task-role"
  mock_outputs            = {
    iam_role_arn          = "arn:aws:iam::123456789012:role/mock-iam-role-arn"
  }
}

dependency "rds" {
  config_path             = "../../initial-infrastructure/aws-service-rds"
  mock_outputs            = {
    username              = "mock-username"
    password              = "mock-password"
    endpoint              = "mock-endpoint"
    port                  = "mock-port"
    cluster_identifier    = "mock-cluster-identifier"
  }
}

dependency "secret_manager_rds" {
  config_path             = "../aws-service-secret-manager"
  mock_outputs            = {
    secret_arn            = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mock"
  }
}

inputs                        = {
  region                      = "us-east-1"
  name_service                = "${local.service}"
  
  ecs_task                    = {
    cpu                       = "512"
    memory                    = "2048"
    container_image           = "public.ecr.aws/p0a9i7q5/metabase-starburst:latest"
    container_port_mappings   = [
      {
        containerPort         = 3000,
        hostPort              = 3000,
      }
    ]
    environment = [
      {
        name                  = "REGION"
        value                 = "us-east-1"
      },
      {
        name                  = "MB_DB_TYPE"
        value                 = "mysql"
      },
      {
        name                  = "MB_DB_DBNAME"
        value                 = "metabase"
      }
    ]

    secrets = [
      {
        name                  = "MB_DB_PORT"
        valueFrom             = "${dependency.secret_manager_rds.outputs.secret_arn}:port::"
      },
      {
        name                  = "MB_DB_USER"
        valueFrom             = "${dependency.secret_manager_rds.outputs.secret_arn}:username::"
      },
      {
        name                  = "MB_DB_PASS"
        valueFrom             = "${dependency.secret_manager_rds.outputs.secret_arn}:password::"
      },
      {
        name                  = "MB_DB_HOST"
        valueFrom             = "${dependency.secret_manager_rds.outputs.secret_arn}:host::"
      }
    ]
  }

  target_group_config = {
    name                      = "${local.service}"
    port                      = 3000
    vpc_id                    = dependency.vpc.outputs.vpc_id
    health_check_port         = "3000"
    health_check_interval     = 30
    health_check_timeout      = 20
    healthy_threshold         = 5
    unhealthy_threshold       = 2
  }

  ecs_cluster_id              = dependency.ecs_cluster.outputs.ecs_cluster_id
  ecs_cluster_name            = dependency.ecs_cluster.outputs.ecs_cluster_name
  listener_port               = 3000
  nlb_arn                     = dependency.load_balancer.outputs.nlb_arn

  subnet_ids                  = dependency.vpc.outputs.private_subnet_ids
  security_group_id           = dependency.vpc.outputs.ecs_security_group_id

  ecs_task_execution_role_arn = dependency.task_execution.outputs.iam_role_arn
  ecs_task_role_arn           = dependency.task_role.outputs.iam_role_arn

  ecs_service_autoscaling     = {
    min_capacity              = #{aws_autoscaling_min_capacity}#
    max_capacity              = #{aws_autoscaling_max_capacity}#
    cpu_target_value          = #{aws_autoscaling_cpu_target_value}#
    memory_target_value       = #{aws_autoscaling_memory_target_value}#
  }
}
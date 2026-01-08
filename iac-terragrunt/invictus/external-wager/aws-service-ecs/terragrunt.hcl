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
  config_path                 = "../../initial-infrastructure/aws-service-vpc"
  mock_outputs                = {
    private_subnet_ids        = ["mock_private_subnet_ids"]
    ecs_security_group_id     = "mock-sg-1234567890"
  }
}

dependency "ecs_cluster" {
  config_path                 = "../../initial-infrastructure/aws-service-ecs-cluster"
  mock_outputs                = {
    ecs_cluster_id            = "mock-ecs-cluster-id"
  }
}

dependency "load_balancer" {
  config_path                 = "../../initial-infrastructure/aws-service-load-balancer"
  mock_outputs                = {
    nlb_arn                   = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/mock-nlb-arn"
  }
}

dependency "task_execution" {
  config_path                 = "../../initial-infrastructure/aws-service-iam-profile/ecs-task-execution-role"
  mock_outputs                = {
    iam_role_arn              = "arn:aws:iam::123456789012:role/mock-iam-role-arn"
  }
}

dependency "task_role" {
  config_path                 = "../../initial-infrastructure/aws-service-iam-profile/ecs-task-role"
  mock_outputs                = {
    iam_role_arn              = "arn:aws:iam::123456789012:role/mock-iam-role-arn"
  }
}

inputs                        = {
  region                      = "us-east-1"
  name_service                = "${local.service}"
  
  ecs_task                    = {
    cpu                       = "256"
    memory                    = "512"
    container_image           = "861262569826.dkr.ecr.us-east-1.amazonaws.com/microservice-${local.service}-#{aws_container_image}#:latest"
    container_port_mappings   = [
      {
        containerPort         = 8080,
        hostPort              = 8080
      }
    ]
    environment               = [
      {
        name                  = "PORT"
        value                 = "8080"
      },
      {
        name                  = "REGION"
        value                 = "us-east-1"
      }
    ]
  }

  target_group_config         = {
    name                      = "${local.service}"
    port                      = 8080
    vpc_id                    = dependency.vpc.outputs.vpc_id
    health_check_port         = "8080"
    health_check_interval     = 30
    health_check_timeout      = 20
    healthy_threshold         = 5
    unhealthy_threshold       = 2
  }

  ecs_cluster_id              = dependency.ecs_cluster.outputs.ecs_cluster_id
  ecs_cluster_name            = dependency.ecs_cluster.outputs.ecs_cluster_name
  listener_port               = 8108
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
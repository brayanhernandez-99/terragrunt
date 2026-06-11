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

inputs = {
  enable_nlb            = false
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
    cpu    = "#{aws_cpu_256}#"
    memory = "#{aws_memory_512}#"
    image  = "861262569826.dkr.ecr.#{aws_region}#.amazonaws.com/microservice-${local.service}-#{aws_container_image}#:latest"
    portMappings = [
      {
        containerPort = 8080
      }
    ]
    environment = [
      {
        name  = "ENVIRONMENT"
        value = "#{aws_environment}#"
      },
      {
        name  = "PORT"
        value = "8080"
      },
      {
        name  = "MICROSERVICE"
        value = "SCHEDULER"
      },
      {
        name  = "REGION"
        value = "#{aws_region}#"
      }
    ]
    health_check = {
      command     = ["CMD-SHELL", "curl -kf http://localhost:8080/health || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 80
    }
  }
}

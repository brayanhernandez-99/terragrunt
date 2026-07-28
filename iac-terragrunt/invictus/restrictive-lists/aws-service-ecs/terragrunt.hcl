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
    private_subnet_ids    = ["subnet-1234567890abcdef0"]
    ecs_security_group_id = "sg-0a1b2c3d4e5f67890"
  }
}

dependency "cloudmap" {
  config_path = "../../initial-infrastructure/aws-service-cloudmap"
  mock_outputs = {
    cloudmap_namespace_id = "ns-0a1b2c3d4e5f67890"
  }
}

dependency "ecs_cluster" {
  config_path = "../../initial-infrastructure/aws-service-ecs-cluster"
  mock_outputs = {
    ecs_cluster_id = "arn:aws:ecs:us-east-1:123456789012:cluster/ecs-cluster"
  }
}

dependency "task_execution" {
  config_path = "../../initial-infrastructure/aws-service-iam-role/ecs-task-execution-role"
  mock_outputs = {
    role_arn = "arn:aws:iam::123456789012:role/role"
  }
}

dependency "task_role" {
  config_path = "../../initial-infrastructure/aws-service-iam-role/ecs-task-role"
  mock_outputs = {
    role_arn = "arn:aws:iam::123456789012:role/role"
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
    image  = "${get_aws_account_id()}.dkr.ecr.#{aws_region}#.amazonaws.com/microservice-${local.service}-invictus:latest"
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
        value = "RESTRICTIVE_LISTS"
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

  ecs_service_autoscaling = {
    min_capacity        = 1
    max_capacity        = 40
    cpu_target_value    = 50
    memory_target_value = 50
  }
}

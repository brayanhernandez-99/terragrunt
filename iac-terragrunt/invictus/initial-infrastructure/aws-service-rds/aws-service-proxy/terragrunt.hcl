include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-rds-proxy"
}

dependency "vpc" {
  config_path = "../../aws-service-vpc"
  mock_outputs = {
    private_subnet_ids = ["subnet-mock-1", "subnet-mock-2"]
  }
}

dependency "rds" {
  config_path = "../aws-service-rds"
  mock_outputs = {
    cluster_identifier = "mock-cluster-identifier"
  }
}

dependency "role" {
  config_path = "../aws-service-iam-role"
  mock_outputs = {
    role_arn = "mock-role-arn"
  }
}

dependency "sg" {
  config_path = "../aws-service-sg"
  mock_outputs = {
    security_group_id = "sg-mock"
  }
}

inputs = {
  name                         = "rds-proxy-invictus"
  role_arn                     = dependency.role.outputs.role_arn
  subnet_ids                   = dependency.vpc.outputs.private_subnet_ids
  security_group_ids           = [dependency.sg.outputs.security_group_id]
  db_cluster_identifier        = dependency.rds.outputs.cluster_identifier
  max_connections_percent      = 100
  max_idle_connections_percent = 50
  connection_borrow_timeout    = 120

  secret_names = [
    "astro-relational-rds-secret",
    "awards-relational-rds-secret",
    "biometrics-relational-rds-secret",
    "collected-relational-rds-secret",
    "conciliation-relational-rds-secret",
    # "credits-relational-rds-secret",
    "dynamic-storage-relational-rds-secret",
    "external-wager-relational-rds-secret",
    "hierarchies-relational-rds-secret",
    "generic-services-relational-rds-secret",
    "lotteries-relational-rds-secret",
    "lotteries-games-relational-rds-secret",
    "lotteries-games-admin-relational-rds-secret",
    "metabase-relational-rds-secret",
    "millonario-relational-rds-secret",
    "money-control-relational-rds-secret",
    "notifications-relational-rds-secret",
    "online-games-relational-rds-secret",
    "papelery-relational-rds-secret",
    "payment-voucher-relational-rds-secret",
    "payments-relational-rds-secret",
    "products-relational-rds-secret",
    "promotional-relational-rds-secret",
    "raffles-relational-rds-secret",
    # "raspa-relational-rds-secret",
    "recharges-relational-rds-secret",
    "remittances-relational-rds-secret",
    "security-relational-rds-secret",
    "sellers-relational-rds-secret",
    "wiretransfer-relational-rds-secret"
  ]
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-iam-role"
}

dependency "secret_astro" {
  config_path = "../../../astro/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_awards" {
  config_path = "../../../awards/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_biometrics" {
  config_path = "../../../biometrics/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_collected" {
  config_path = "../../../collected/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_conciliation" {
  config_path = "../../../conciliation/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_credits" {
  config_path = "../../../credits/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_dynamic_storage" {
  config_path = "../../../dynamic-storage/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_external_wager" {
  config_path = "../../../external-wager/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_generic_services" {
  config_path = "../../../generic-services/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_hierarchies" {
  config_path = "../../../hierarchies/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_lotteries" {
  config_path = "../../../lotteries/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_lotteries_games" {
  config_path = "../../../lotteries-games/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_lotteries_games_admin" {
  config_path = "../../../lotteries-games-admin/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_metabase" {
  config_path = "../../../metabase/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_millonario" {
  config_path = "../../../millonario/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_money_control" {
  config_path = "../../../money-control/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_notifications" {
  config_path = "../../../notifications/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_online_games" {
  config_path = "../../../online-games/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_papelery" {
  config_path = "../../../papelery/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_payment_voucher" {
  config_path = "../../../payment-voucher/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_payments" {
  config_path = "../../../payments/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_products" {
  config_path = "../../../products/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_promotional" {
  config_path = "../../../promotional/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_raffles" {
  config_path = "../../../raffles/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_raspa" {
  config_path = "../../../raspa/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_recharges" {
  config_path = "../../../recharges/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_remittances" {
  config_path = "../../../remittances/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_security" {
  config_path = "../../../security/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_sellers" {
  config_path = "../../../sellers/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_shopping_cart" {
  config_path = "../../../shopping-cart/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_trino" {
  config_path = "../../../trino/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

dependency "secret_wiretransfer" {
  config_path = "../../../wiretransfer/aws-service-secret-manager"
  mock_outputs = {
    secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:secret"
  }
}

inputs = {
  role_name = "rds-proxy-invictus-role"

  assume_role_policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  }

  policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "GetSecretValue"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          dependency.secret_astro.outputs.secret_arn,
          dependency.secret_awards.outputs.secret_arn,
          dependency.secret_biometrics.outputs.secret_arn,
          dependency.secret_collected.outputs.secret_arn,
          dependency.secret_conciliation.outputs.secret_arn,
          dependency.secret_credits.outputs.secret_arn,
          dependency.secret_dynamic_storage.outputs.secret_arn,
          dependency.secret_external_wager.outputs.secret_arn,
          dependency.secret_generic_services.outputs.secret_arn,
          dependency.secret_hierarchies.outputs.secret_arn,
          dependency.secret_lotteries.outputs.secret_arn,
          dependency.secret_lotteries_games.outputs.secret_arn,
          dependency.secret_lotteries_games_admin.outputs.secret_arn,
          dependency.secret_metabase.outputs.secret_arn,
          dependency.secret_millonario.outputs.secret_arn,
          dependency.secret_money_control.outputs.secret_arn,
          dependency.secret_notifications.outputs.secret_arn,
          dependency.secret_online_games.outputs.secret_arn,
          dependency.secret_papelery.outputs.secret_arn,
          dependency.secret_payment_voucher.outputs.secret_arn,
          dependency.secret_payments.outputs.secret_arn,
          dependency.secret_products.outputs.secret_arn,
          dependency.secret_promotional.outputs.secret_arn,
          dependency.secret_raffles.outputs.secret_arn,
          dependency.secret_raspa.outputs.secret_arn,
          dependency.secret_recharges.outputs.secret_arn,
          dependency.secret_remittances.outputs.secret_arn,
          dependency.secret_security.outputs.secret_arn,
          dependency.secret_sellers.outputs.secret_arn,
          dependency.secret_shopping_cart.outputs.secret_arn,
          dependency.secret_trino.outputs.secret_arn,
          dependency.secret_wiretransfer.outputs.secret_arn
        ]
      }
    ]
  }
}

resource "random_uuid" "external_id" {
}

# Description                  : This file contains the terraform configuration to create a Cognito User Pool and User Pool Client
resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name

  username_attributes = var.username_attributes

  password_policy {
    minimum_length    = var.password_min_length
    require_uppercase = var.password_require_uppercase
    require_lowercase = var.password_require_lowercase
    require_numbers   = var.password_require_numbers
    require_symbols   = var.password_require_symbols
  }

  auto_verified_attributes = var.auto_verified_attributes

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_email"
      priority = 2
    }
  }

  dynamic "schema" {
    for_each = var.custom_attributes
    content {
      attribute_data_type = "String"
      name                = schema.key
      mutable             = schema.value.mutable
      string_attribute_constraints {
        min_length = schema.value.min_length
        max_length = schema.value.max_length
      }
    }
  }

  verification_message_template {
    default_email_option = var.verification_template.default_email_option
    email_subject        = var.verification_template.email_subject
    email_message        = var.verification_template.email_message
    sms_message          = var.verification_template.sms_message
  }

  admin_create_user_config {
    invite_message_template {
      email_subject = var.invitation_template.email_subject
      email_message = var.invitation_template.email_message
      sms_message   = var.invitation_template.sms_message
    }
  }

  mfa_configuration          = var.mfa_configuration
  sms_authentication_message = var.sms_message

  sms_configuration {
    external_id    = "${var.user_pool_name}-${random_uuid.external_id.result}"
    sns_caller_arn = aws_iam_role.sns_role.arn
  }

  lambda_config {
    custom_message       = var.message_lambda_arn
    pre_authentication   = var.pre_authentication_lambda_arn
    pre_token_generation = var.pre_token_generation_lambda_arn
  }
}

# Cognito User Pool Domain
resource "aws_cognito_user_pool_client" "userpool_client" {
  name            = var.app_client_name
  user_pool_id    = aws_cognito_user_pool.user_pool.id
  generate_secret = var.generate_secret

  allowed_oauth_flows          = var.allowed_oauth_flows
  explicit_auth_flows          = var.allowed_authentication_flows
  allowed_oauth_scopes         = var.allowed_oauth_scopes
  callback_urls                = var.callback_urls
  logout_urls                  = var.logout_urls
  supported_identity_providers = var.supported_identity_providers

  access_token_validity   = var.access_token_validity
  id_token_validity       = var.id_token_validity
  refresh_token_validity  = var.refresh_token_validity
  enable_token_revocation = var.enable_token_revocation
}

resource "aws_iam_role" "sns_role" {
  name = "${var.user_pool_name}-sns-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cognito-idp.amazonaws.com"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "sts:ExternalId" : "${var.user_pool_name}-${random_uuid.external_id.result}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "sns_policy" {
  name = "${var.user_pool_name}-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sns:publish"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_ecr_download_role_policy_attachment" {
  role       = aws_iam_role.sns_role.name
  policy_arn = aws_iam_policy.sns_policy.arn
}
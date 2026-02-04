include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-cognito"
}

inputs = {
  user_pool_name             = "invictus-user-pool"
  username_attributes        = ["phone_number"]
  password_min_length        = 8
  password_require_uppercase = true
  password_require_lowercase = true
  password_require_numbers   = true
  password_require_symbols   = true
  auto_verified_attributes   = ["email"]
  mfa_configuration          = "OFF"
  custom_attributes = {
    "equipment" = {
      required = true
      mutable  = true
    },
    "expeditionDate" = {
      required = true
      mutable  = true
    },
    "hash" = {
      required = true
      mutable  = true
    },
    "id" = {
      required = true
      mutable  = true
    },
    "idType" = {
      required = true
      mutable  = true
    },
    "roles" = {
      required = true
      mutable  = true
    },
    "state" = {
      required = true
      mutable  = true
    },
    "urlIdentification" = {
      required = true
      mutable  = true
    },
    # "updated_at"             = {
    #   required               = true
    #   mutable                = true
    # },
    "updated_by" = {
      required = true
      mutable  = true
    },
  }

  verification_template = {
    email_subject        = "Confirma tu cuenta"
    email_message        = "Hola {username}, usa este código {####} para verificar tu cuenta."
    sms_message          = "Tu código de verificación es {####}."
    default_email_option = "CONFIRM_WITH_CODE"
  }

  invitation_template = {
    email_subject = "Bienvenido a nuestra aplicación"
    email_message = "Hola {username}, tu cuenta ha sido creada. Tu código temporal es {####}."
    sms_message   = "Tu cuenta ha sido creada {username}. Código temporal: {####}."
  }

  sms_message             = "Tu código de autenticación es {####}."
  access_token_validity   = 1
  id_token_validity       = 1
  refresh_token_validity  = 1
  enable_token_revocation = true
}

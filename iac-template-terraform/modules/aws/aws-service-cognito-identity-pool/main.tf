resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name               = "invictus-identity-pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    provider_name           = "cognito-idp.us-east-1.amazonaws.com/${var.user_pool_id}"
    client_id               = var.user_pool_client_id
    server_side_token_check = false
  }
}

resource "aws_iam_role" "authenticated_role" {
  name = "idp-invictus"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = "cognito-identity.amazonaws.com" }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "cognito-identity.amazonaws.com:aud" = "${aws_cognito_identity_pool.identity_pool.id}"
        },
        "ForAnyValue:StringLike" = {
          "cognito-identity.amazonaws.com:amr" = "authenticated"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "cognito_get_credentials_policy" {
  name        = "Cognito-unauthenticated"
  description = "Permite obtener credenciales temporales en Cognito"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["cognito-identity:GetCredentialsForIdentity"]
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cognito_credentials_attachment" {
  role       = aws_iam_role.authenticated_role.name
  policy_arn = aws_iam_policy.cognito_get_credentials_policy.arn
}

resource "aws_iam_role_policy_attachment" "cognitopower" {
  role       = aws_iam_role.authenticated_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoPowerUser"
}

resource "aws_iam_role_policy_attachment" "AmazonESCognitoAccess" {
  role       = aws_iam_role.authenticated_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonESCognitoAccess"
}

resource "aws_iam_role_policy_attachment" "AWSIoTConfigAccess" {
  role       = aws_iam_role.authenticated_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSIoTConfigAccess"
}

resource "aws_iam_role_policy_attachment" "AWSIoTDataAccess" {
  role       = aws_iam_role.authenticated_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSIoTDataAccess"
}

resource "aws_cognito_identity_pool_roles_attachment" "identity_roles" {
  identity_pool_id = aws_cognito_identity_pool.identity_pool.id

  roles = {
    "authenticated" = aws_iam_role.authenticated_role.arn
  }
}
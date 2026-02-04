include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-iam-roles"
}

inputs = {
  iam_role_name = "DevelopmentRole"
  iam_policies_map = {
    policy-development-role1 = {
      name = "policy-development-role"
      policy_json = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Action" : [
              "sts:AssumeRole"
            ],
            "Resource" : "arn:aws:iam::861262569826:role/DevelopmentRol",
            "Effect" : "Allow"
          }
        ]
      })
      use_suffix = true
    },

    policy-development-role2 = {
      name = "Assumerol-DevelopmentRol"
      policy_json = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Sid" : "VisualEditor0",
            "Effect" : "Allow",
            "Action" : "sts:AssumeRole",
            "Resource" : "arn:aws:iam::861262569826:role/DevelopmentRole"
          }
        ]
      })
      use_suffix = false
    },

    Amazon_S3_FullAccess = {
      name        = "AmazonS3FullAccess"
      managed_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    }

    Amazon_EventBridge_Full_Access = {
      name        = "AmazonEventBridgeFullAccess "
      managed_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
    }

    AWS_CloudFormation_FullAccess = {
      name        = "AWSCloudFormationFullAccess"
      managed_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
    }

    AWS_Code_Artifact_ReadOnlyAccess = {
      name        = "AWSCodeArtifactReadOnlyAccess "
      managed_arn = "arn:aws:iam::aws:policy/AWSCodeArtifactReadOnlyAccess"
    }

    policy-development-role3 = {
      name = "DevelopmentRoleIAM"
      policy_json = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Sid" : "VisualEditor0",
            "Effect" : "Allow",
            "Action" : [
              "iam:GetAccountPasswordPolicy",
              "iam:ListRoleTags",
              "iam:GenerateServiceLastAccessedDetails",
              "iam:ListServiceSpecificCredentials",
              "iam:PutRolePolicy",
              "iam:ListSigningCertificates",
              "iam:SimulateCustomPolicy",
              "iam:DeleteServerCertificate",
              "iam:DetachGroupPolicy",
              "iam:ListRolePolicies",
              "iam:GetCredentialReport",
              "iam:PutGroupPolicy",
              "iam:ListPolicies",
              "iam:UpdateServiceSpecificCredential",
              "iam:GetRole",
              "iam:GetPolicy",
              "iam:RemoveClientIDFromOpenIDConnectProvider",
              "iam:ListEntitiesForPolicy",
              "iam:DeleteRole",
              "iam:UpdateRoleDescription",
              "iam:TagPolicy",
              "iam:GetOpenIDConnectProvider",
              "iam:GetRolePolicy",
              "iam:CreateInstanceProfile",
              "iam:GenerateCredentialReport",
              "iam:UntagRole",
              "iam:TagRole",
              "iam:DeleteRolePermissionsBoundary",
              "iam:GetServiceLastAccessedDetails",
              "iam:GetServiceLinkedRoleDeletionStatus",
              "iam:ListInstanceProfilesForRole",
              "iam:PassRole",
              "iam:DeleteRolePolicy",
              "iam:ListAttachedGroupPolicies",
              "iam:ListPolicyTags",
              "iam:DeleteAccountAlias",
              "iam:ListAccessKeys",
              "iam:ListGroupPolicies",
              "iam:GetSSHPublicKey",
              "iam:ListRoles",
              "iam:GetContextKeysForCustomPolicy",
              "iam:CreatePolicy",
              "iam:AttachGroupPolicy",
              "iam:ListServerCertificateTags",
              "iam:PutUserPolicy",
              "iam:TagServerCertificate",
              "iam:ListAccountAliases",
              "iam:UntagPolicy",
              "iam:UpdateRole",
              "iam:GetUser",
              "iam:ListGroups",
              "iam:UntagInstanceProfile",
              "iam:DeleteServiceSpecificCredential",
              "iam:GetLoginProfile",
              "iam:TagInstanceProfile",
              "iam:SetDefaultPolicyVersion",
              "iam:UpdateAssumeRolePolicy",
              "iam:GetPolicyVersion",
              "iam:DeleteGroup",
              "iam:ListServerCertificates",
              "iam:RemoveRoleFromInstanceProfile",
              "iam:UpdateGroup",
              "iam:CreateRole",
              "iam:AttachRolePolicy",
              "iam:CreateLoginProfile",
              "iam:ListSSHPublicKeys",
              "iam:DetachRolePolicy",
              "iam:SimulatePrincipalPolicy",
              "iam:ListAttachedRolePolicies",
              "iam:ListOpenIDConnectProviderTags",
              "iam:DetachUserPolicy",
              "iam:GetAccountAuthorizationDetails",
              "iam:GetServerCertificate",
              "iam:CreateGroup",
              "iam:GetAccessKeyLastUsed",
              "iam:DeleteUserPolicy",
              "iam:DeleteSigningCertificate",
              "iam:GetUserPolicy",
              "iam:ListGroupsForUser",
              "iam:DeleteServiceLinkedRole",
              "iam:GetGroupPolicy",
              "iam:GetAccountSummary",
              "iam:GetServiceLastAccessedDetailsWithEntities",
              "iam:ListPoliciesGrantingServiceAccess",
              "iam:DeleteSSHPublicKey",
              "iam:DeletePolicy",
              "iam:ListInstanceProfileTags",
              "iam:GetGroup",
              "iam:GetOrganizationsAccessReport",
              "iam:GetContextKeysForPrincipalPolicy",
              "iam:GenerateOrganizationsAccessReport",
              "iam:ListAttachedUserPolicies",
              "iam:CreatePolicyVersion",
              "iam:GetInstanceProfile",
              "iam:UntagServerCertificate",
              "iam:ListUserPolicies",
              "iam:ListInstanceProfiles",
              "iam:ListPolicyVersions",
              "iam:ListOpenIDConnectProviders",
              "iam:ListUsers",
              "iam:UpdateSigningCertificate",
              "iam:DeleteGroupPolicy",
              "iam:DeletePolicyVersion",
              "iam:ListUserTags",
              "iam:CreateServiceLinkedRole"
            ],
            "Resource" : "*"
          }
        ]
      })
      use_suffix = false
    },

    policy-development-role4 = {
      name = "DevelopmentRolePolicy"
      policy_json = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Sid" : "VisualEditor0",
            "Effect" : "Allow",
            "Action" : "kms:*",
            "Resource" : [
              "arn:aws:kms:us-east-1:152266913008:alias/Key-*",
              "arn:aws:kms:us-east-1:152266913008:key/Key-*",
              "arn:aws:kms:us-east-1:152266913008:key/*",
              "arn:aws:kms:us-east-1:152266913008:*"
            ]
          },
          {
            "Sid" : "VisualEditor1",
            "Effect" : "Allow",
            "Action" : [
              "rds:*",
              "route53:ListTrafficPolicyVersions",
              "cognito-identity:CreateIdentityPool",
              "route53:ListHostedZonesByName",
              "kms:UpdateCustomKeyStore",
              "events:RemoveTargets",
              "route53:GetHostedZoneCount",
              "events:DescribeRule",
              "route53:GetHealthCheckLastFailureReason",
              "apigateway:*",
              "events:ListConnections",
              "route53:ListVPCAssociationAuthorizations",
              "events:TestEventPattern",
              "networkmanager:GetTransitGatewayRegistrations",
              "route53:ListTagsForResources",
              "events:DescribeArchive",
              "ecs:*",
              "events:ListTagsForResource",
              "route53:GetGeoLocation",
              "ec2:*",
              "events:RemovePermission",
              "networkmanager:GetDevices",
              "networkmanager:GetTransitGatewayConnectPeerAssociations",
              "kms:GenerateRandom",
              "iot:*",
              "events:PutRule",
              "events:DescribePartnerEventSource",
              "cognito-identity:GetIdentityPoolRoles",
              "route53:ListQueryLoggingConfigs",
              "route53:ListHostedZonesByVPC",
              "route53:GetCheckerIpRanges",
              "events:DescribeReplay",
              "cognito-identity:SetIdentityPoolRoles",
              "networkmanager:GetLinks",
              "kms:CreateKey",
              "route53:ListGeoLocations",
              "networkmanager:GetSites",
              "networkmanager:ListTagsForResource",
              "events:DisableRule",
              "events:ListReplays",
              "s3:*",
              "route53:ListHostedZones",
              "networkmanager:GetConnections",
              "events:DescribeEventSource",
              "events:ListEventBuses",
              "route53:ListTagsForResource",
              "events:ListArchives",
              "events:DeleteRule",
              "route53:ListHealthChecks",
              "kms:ListAliases",
              "ssm:*",
              "elasticloadbalancing:DescribeTargetGroups",
              "ecr:*",
              "networkmanager:DescribeGlobalNetworks",
              "application-autoscaling:*",
              "route53:GetHostedZone",
              "logs:*",
              "dynamodb:*",
              "elasticloadbalancing:DescribeLoadBalancers",
              "kms:DescribeCustomKeyStores",
              "cloudfront:*",
              "events:ListRuleNamesByTarget",
              "secretsmanager:*",
              "events:ListPartnerEventSources",
              "route53:ListResourceRecordSets",
              "events:ListRules",
              "kinesis:*",
              "kms:ConnectCustomKeyStore",
              "events:ListTargetsByRule",
              "route53:GetHealthCheckCount",
              "route53:ListReusableDelegationSets",
              "route53:ListTrafficPolicyInstancesByHostedZone",
              "route53:ChangeResourceRecordSets",
              "cloudformation:*",
              "kms:CreateCustomKeyStore",
              "events:DescribeEventBus",
              "sts:AssumeRole",
              "cognito-idp:*",
              "route53:ListTrafficPolicyInstances",
              "route53:GetChange",
              "events:DescribeConnection",
              "networkmanager:GetCustomerGatewayAssociations",
              "events:ListPartnerEventSourceAccounts",
              "kms:DeleteCustomKeyStore",
              "events:ListEventSources",
              "route53:ListTrafficPolicies",
              "networkmanager:GetLinkAssociations",
              "events:DescribeApiDestination",
              "route53:GetHealthCheckStatus",
              "events:ListApiDestinations",
              "elasticloadbalancing:*",
              "route53:GetReusableDelegationSet",
              "events:PutPermission",
              "kms:ListKeys",
              "events:PutTargets",
              "route53:ListTrafficPolicyInstancesByPolicy",
              "lambda:*",
              "kms:DisconnectCustomKeyStore",
              "codeartifact:*",
              "sqs:*"
            ],
            "Resource" : "*"
          }
        ]
      })
      use_suffix = false
    }

  }
}

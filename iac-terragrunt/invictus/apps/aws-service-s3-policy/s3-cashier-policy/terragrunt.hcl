include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-s3-policy"
}

dependency "s3" {
  config_path = "../../aws-service-s3/s3-cashier"
  mock_outputs = {
    s3_bucket_id   = "s3-bucket-id"
    s3_bucket_name = "s3-bucket-name"
    s3_bucket_arn  = "arn:aws:s3:::s3-bucket"
  }
}

dependency "cloudfront" {
  config_path = "../../aws-service-cloudfront/cloudfront-cashier"
  mock_outputs = {
    cloudfront_arn = "arn:aws:cloudfront::123456789012:distribution/distribution"
  }
}

inputs = {
  s3_bucket_id  = dependency.s3.outputs.s3_bucket_id
  s3_bucket_arn = dependency.s3.outputs.s3_bucket_arn

  s3_bucket_policy = {
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${dependency.s3.outputs.s3_bucket_name}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = dependency.cloudfront.outputs.cloudfront_arn
          }
        }
      }
    ]
  }
}

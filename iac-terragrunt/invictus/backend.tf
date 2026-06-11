terraform {
  backend "s3" {
    bucket = "#{aws_bucket}#"
    key    = "./terraform.tfstate"
    region = "#{aws_region}#"
  }
}

provider "aws" {
  region = "us-west-2"
}

locals {
  s3_origin_id = "access-identity-serverless-series-spa"
  region       = "us-west-2"
}

data "aws_caller_identity" "current" {}

output "base_url" {
  value = {
    api_staging = aws_api_gateway_deployment.staging.invoke_url
    api_production = aws_api_gateway_deployment.production.invoke_url
    web = aws_cloudfront_distribution.s3_distribution.domain_name
  }
}

resource "aws_s3_bucket" "serverless_series_spa" {
  bucket        = "serverless-series-spa"
  acl           = "private"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "null_resource" "yarn_install" {
  depends_on = [

  ]

  provisioner "local-exec" {
    command = <<-EOT
      cd ${path.module}/front-end && yarn install
    EOT
  }
}

resource "null_resource" "replace" {
  depends_on = [
    null_resource.yarn_install,
    aws_api_gateway_deployment.staging
  ]

  provisioner "local-exec" {
    command = <<-EOT
      cd ${path.module}/front-end && sed -i "s|staging_api|${aws_api_gateway_deployment.staging.invoke_url}|g" .env-cmdrc
    EOT
  }
}

resource "null_resource" "yarn_build" {
  depends_on = [
    null_resource.replace
  ]

  provisioner "local-exec" {
    command = <<-EOT
      cd ${path.module}/front-end && yarn build:staging
    EOT
  }
}

resource "null_resource" "upload" {
  depends_on = [
    null_resource.yarn_build,
    aws_s3_bucket.serverless_series_spa
  ]

  provisioner "local-exec" {
    command = <<-EOT
      cd ${path.module}/front-end && aws s3 cp build s3://serverless-series-spa --recursive
    EOT
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.serverless_series_spa.arn}/*"]

    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.serverless_series_spa.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

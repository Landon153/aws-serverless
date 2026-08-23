resource "aws_s3_bucket" "serverless-series-spa" {
  bucket = "serverless-series-spa"
  acl    = "public-read"
  policy = file("policies/s3_spa_policy.json")

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket" "serverless-series-upload" {
  bucket = "serverless-series-upload"
  acl    = "public-read"
  policy = file("policies/s3_upload_policy.json")
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = [
      "PUT",
      "POST",
      "DELETE"
    ]
    allowed_origins = ["*"]
    expose_headers = []
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_api_gateway_rest_api" "books" {
  name = "books-api"

  binary_media_types = [
    "multipart/form-data",
    "*/*"
  ]
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.books_list,
    aws_api_gateway_integration.books_create,
    aws_api_gateway_integration.books_delete,
    aws_api_gateway_integration.books_get,
    aws_api_gateway_integration.login,
    aws_api_gateway_integration.change_password,
  ]

  rest_api_id = aws_api_gateway_rest_api.books.id
  stage_name  = "staging"
}

output "base_url" {
  value = {
    api = aws_api_gateway_deployment.deployment.invoke_url
    web = aws_s3_bucket.serverless-series-spa.website_endpoint
  }
}

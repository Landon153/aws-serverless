provider "aws" {
  region = "us-west-2"
}

resource "aws_api_gateway_rest_api" "books" {
  name = "books-api"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.books_list,
    aws_api_gateway_integration.books_create,
    aws_api_gateway_integration.books_update,
    aws_api_gateway_integration.books_delete,
    aws_api_gateway_integration.books_get,
  ]

  rest_api_id = aws_api_gateway_rest_api.books.id
  stage_name  = "staging"
}

output "base_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}

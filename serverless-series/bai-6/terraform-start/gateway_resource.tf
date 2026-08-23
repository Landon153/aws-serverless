resource "aws_api_gateway_resource" "books" {
  rest_api_id = aws_api_gateway_rest_api.books.id
  parent_id   = aws_api_gateway_rest_api.books.root_resource_id
  path_part   = "books"
}

resource "aws_api_gateway_resource" "books_id" {
  rest_api_id = aws_api_gateway_rest_api.books.id
  parent_id   = aws_api_gateway_resource.books.id
  path_part   = "{id}"
}

resource "aws_api_gateway_resource" "login" {
  rest_api_id = aws_api_gateway_rest_api.books.id
  parent_id   = aws_api_gateway_rest_api.books.root_resource_id
  path_part   = "login"
}

resource "aws_api_gateway_resource" "change_password" {
  rest_api_id = aws_api_gateway_rest_api.books.id
  parent_id   = aws_api_gateway_rest_api.books.root_resource_id
  path_part   = "change-password"
}
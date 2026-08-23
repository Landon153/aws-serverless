resource "aws_api_gateway_method" "books_list" {
  rest_api_id   = aws_api_gateway_rest_api.books.id
  resource_id   = aws_api_gateway_resource.books.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "books_create" {
  rest_api_id   = aws_api_gateway_rest_api.books.id
  resource_id   = aws_api_gateway_resource.books.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "books_delete" {
  rest_api_id   = aws_api_gateway_rest_api.books.id
  resource_id   = aws_api_gateway_resource.books.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "books_get" {
  rest_api_id   = aws_api_gateway_rest_api.books.id
  resource_id   = aws_api_gateway_resource.books_id.id
  http_method   = "GET"
  authorization = "NONE"
}
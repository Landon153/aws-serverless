resource "aws_api_gateway_integration" "books_list" {
  rest_api_id = aws_api_gateway_rest_api.books.id
  resource_id = aws_api_gateway_resource.books.id
  http_method = aws_api_gateway_method.books_list.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.function_list.invoke_arn
}

resource "aws_api_gateway_integration" "books_create" {
  rest_api_id = aws_api_gateway_rest_api.books.id
  resource_id = aws_api_gateway_resource.books.id
  http_method = aws_api_gateway_method.books_create.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.function_create.invoke_arn
}

resource "aws_api_gateway_integration" "books_delete" {
  rest_api_id = aws_api_gateway_rest_api.books.id
  resource_id = aws_api_gateway_resource.books.id
  http_method = aws_api_gateway_method.books_delete.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.function_delete.invoke_arn
}

resource "aws_api_gateway_integration" "books_get" {
  rest_api_id = aws_api_gateway_rest_api.books.id
  resource_id = aws_api_gateway_resource.books_id.id
  http_method = aws_api_gateway_method.books_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.function_get.invoke_arn
}

resource "aws_api_gateway_integration" "login" {
  rest_api_id = aws_api_gateway_rest_api.books.id
  resource_id = aws_api_gateway_resource.login.id
  http_method = aws_api_gateway_method.login.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.function_login.invoke_arn
}

resource "aws_api_gateway_integration" "change_password" {
  rest_api_id = aws_api_gateway_rest_api.books.id
  resource_id = aws_api_gateway_resource.change_password.id
  http_method = aws_api_gateway_method.change_password.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.function_change_password.invoke_arn
}
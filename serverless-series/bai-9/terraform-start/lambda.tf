resource "aws_lambda_function" "function_list" {
  function_name = "books_list"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main"
  runtime       = "go1.x"

  filename         = "source/list.zip"
  source_code_hash = filebase64sha256("source/list.zip")
}

resource "aws_lambda_permission" "apigw_list_staging" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function_list.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.books.execution_arn}/*/*"
}

resource "aws_lambda_alias" "function_list_lambda_alias" {
  name             = "production"
  function_name    = aws_lambda_function.function_list.arn
  function_version = "$LATEST"
}

resource "aws_lambda_permission" "apigw_list_production" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.function_list.function_name}:production"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.books.execution_arn}/*/*"
}

resource "aws_lambda_function" "function_notification" {
  function_name = "notification"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main"
  runtime       = "go1.x"

  filename         = "source/notification.zip"
  source_code_hash = filebase64sha256("source/notification.zip")
}

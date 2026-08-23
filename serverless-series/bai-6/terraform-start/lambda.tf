resource "aws_lambda_function" "function_list" {
  function_name = "books_list"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main"
  runtime       = "go1.x"

  filename         = "source/list.zip"
  source_code_hash = filebase64sha256("source/list.zip")
}

resource "aws_lambda_function" "function_create" {
  function_name = "books_create"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main"
  runtime       = "go1.x"

  filename         = "source/create.zip"
  source_code_hash = filebase64sha256("source/create.zip")
}

resource "aws_lambda_function" "function_delete" {
  function_name = "books_delete"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main"
  runtime       = "go1.x"

  filename         = "source/delete.zip"
  source_code_hash = filebase64sha256("source/delete.zip")
}

resource "aws_lambda_function" "function_get" {
  function_name = "books_get"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main"
  runtime       = "go1.x"

  filename         = "source/get.zip"
  source_code_hash = filebase64sha256("source/get.zip")
}

resource "aws_lambda_function" "function_login" {
  function_name = "login"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main"
  runtime       = "go1.x"

  filename         = "source/login.zip"
  source_code_hash = filebase64sha256("source/login.zip")

  environment {
    variables = {
      COGNITO_CLIENT_ID = aws_cognito_user_pool_client.client.id
    }
  }
}

resource "aws_lambda_function" "function_change_password" {
  function_name = "change_password"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main"
  runtime       = "go1.x"

  filename         = "source/change-password.zip"
  source_code_hash = filebase64sha256("source/change-password.zip")

  environment {
    variables = {
      COGNITO_CLIENT_ID = aws_cognito_user_pool_client.client.id
    }
  }
}

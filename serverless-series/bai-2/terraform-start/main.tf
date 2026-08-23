provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = file("policies/lambda_assume_role_policy.json")
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = file("policies/lambda_policy.json")
}

resource "aws_lambda_function" "list" {
  function_name = "books_list"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main"
  runtime       = "go1.x"

  filename         = "source/list.zip"
  source_code_hash = filebase64sha256("source/list.zip")
}

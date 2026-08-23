resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = file("policies/lambda_assume_role_policy.json")
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = file("policies/lambda_policy.json")
}

resource "aws_iam_role" "api_gateway_role" {
  name               = "api_gateway_role"
  assume_role_policy = file("policies/apigateway_assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "api_gateway_policy" {
  role = aws_iam_role.api_gateway_role.id

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

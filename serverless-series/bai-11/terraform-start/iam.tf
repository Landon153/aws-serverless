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

resource "aws_iam_policy" "aws_code_pipeline_service" {
  name   = "AWSCodePipelineServicePolicy"
  policy = file("policies/aws_code_pipeline_service.json")
}

resource "aws_iam_policy" "aws_code_build" {
  name   = "AWSCodeBuildPolicy"
  policy = file("policies/aws_code_build.json")
}

resource "aws_iam_role" "aws_code_pipeline_service" {
  name = "AWSCodePipelineServiceRole"
  path = "/service-role/"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codepipeline.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_code_pipeline_service" {
  role       = aws_iam_role.aws_code_pipeline_service.name
  policy_arn = aws_iam_policy.aws_code_pipeline_service.arn
}

resource "aws_iam_role" "aws_code_build" {
  name        = "AWSCodeBuildRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codebuild.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_code_build" {
  role       = aws_iam_role.aws_code_build.name
  policy_arn = aws_iam_policy.aws_code_build.arn
}
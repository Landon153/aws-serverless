locals {
  list_function_staging  = "list-function-staging"
  list_function_main  = "list-function-main"
}

resource "aws_codebuild_project" "list_function_staging" {
  name         = local.list_function_staging
  service_role = aws_iam_role.aws_code_build.arn

  artifacts {
    name      = aws_s3_bucket.codepipeline_bucket.bucket
    packaging = "NONE"
    type      = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }
}

resource "aws_codepipeline" "list_function_staging" {
  name     = local.list_function_staging
  role_arn = aws_iam_role.aws_code_pipeline_service.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"
      output_artifacts = [
        "SourceArtifact"
      ]

      configuration = {
        ConnectionArn    = var.codestar_connection
        FullRepositoryId = "hoalongnatsu/codepipeline-list-function"
        BranchName       = "staging"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name      = "Build"
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
      input_artifacts = [
        "SourceArtifact",
      ]

      configuration = {
        "ProjectName" = local.list_function_staging
      }
    }
  }
}

resource "aws_codebuild_project" "list_function_main" {
  name         = local.list_function_main
  service_role = aws_iam_role.aws_code_build.arn

  artifacts {
    name      = aws_s3_bucket.codepipeline_bucket.bucket
    packaging = "NONE"
    type      = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
    buildspec           = "deployspec.yaml"
  }
}

resource "aws_codepipeline" "list_function_main" {
  name     = local.list_function_main
  role_arn = aws_iam_role.aws_code_pipeline_service.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"
      output_artifacts = [
        "SourceArtifact"
      ]

      configuration = {
        ConnectionArn    = var.codestar_connection
        FullRepositoryId = "hoalongnatsu/codepipeline-list-function"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name      = "Deploy"
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
      input_artifacts = [
        "SourceArtifact",
      ]

      configuration = {
        "ProjectName" = local.list_function_main
      }
    }
  }
}

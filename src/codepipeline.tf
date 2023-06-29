resource "aws_codepipeline" "cicd_pipeline" {
  name     = "${var.prefix}-pl-${local.name}-${local.suffix}"
  role_arn = aws_iam_role.account_cicd_codepipeline.arn
  artifact_store {
    encryption_key {
      id   = aws_kms_key.account_cicd_codepipeline_key.arn
      type = "KMS"
    }
    location = aws_s3_bucket.account_cicd_codepipeline_bucket.id
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      provider         = "CodeCommit"
      category         = "Source"
      configuration    = {
        BranchName           = var.codecommit_branch_name
        PollForSourceChanges = "false"
        RepositoryName       = var.codecommit_repository_name
      }
      name             = var.codecommit_repository_name
      owner            = "AWS"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      role_arn         = aws_iam_role.codepipeline_codecommit.arn
    }
  }

  stage {
    name = "Plan"
    action {
      category         = "Test"
      configuration    = {
        ProjectName          = aws_codebuild_project.tf_plan.name
        EnvironmentVariables = jsonencode([
          {
            name  = "CODEPIPELINE_STAGE_NAME"
            value = "Plan"
            type  = "PLAINTEXT"
          },
          {
            name  = "PREFIX"
            value = var.prefix
            type  = "PLAINTEXT"
          },
          {
            name  = "TF_CMD"
            value = "plan"
            type  = "PLAINTEXT"
          },
          {
            name  = "TF_OPTION"
            value = "-input=false -no-color"
          }
        ])
      }
      input_artifacts  = ["SourceArtifact"]
      name             = aws_codebuild_project.tf_plan.name
      provider         = "CodeBuild"
      owner            = "AWS"
      version          = "1"
      namespace        = "PLAN"
      role_arn         = aws_iam_role.codepipeline_codebuild.arn
      output_artifacts = [
        "Artifact_Build_CodeBuild_Plan"
      ]
    }
  }

  stage {
    name = "Build"
    action {
      category         = "Build"
      configuration    = {
        ProjectName          = aws_codebuild_project.tf_apply.name
        EnvironmentVariables = jsonencode([
          {
            name  = "CODEPIPELINE_STAGE_NAME"
            value = "Build"
            type  = "PLAINTEXT"
          },
          {
            name  = "DESTINATION_BUILD_SERVICE_ROLE_ARN"
            value = aws_iam_role.codebuild_tf_apply.arn
            type  = "PLAINTEXT"
          },
          {
            name  = "PREFIX"
            value = var.prefix
            type  = "PLAINTEXT"
          },
          {
            name  = "TF_CMD"
            value = "apply"
            type  = "PLAINTEXT"
          },
          {
            name  = "TF_OPTION"
            value = "-input=false -no-color -auto-approve"
          }
        ])
      }
      input_artifacts  = ["SourceArtifact"]
      name             = aws_codebuild_project.tf_apply.name
      provider         = "CodeBuild"
      owner            = "AWS"
      version          = "1"
      role_arn         = aws_iam_role.codepipeline_codebuild.arn
      output_artifacts = [
        "Artifact_Build_CodeBuild"
      ]
    }
  }
}

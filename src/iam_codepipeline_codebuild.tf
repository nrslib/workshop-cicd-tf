resource "aws_iam_role" "codepipeline_codebuild" {
  name               = "${var.prefix}-pl-build-${local.name}-${local.suffix}"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "sts:AssumeRole",
        Principal : {
          AWS : aws_iam_role.account_cicd_codepipeline.arn
        },
      }
    ]
  })
}

resource "aws_iam_role_policy" "codepipeline_codebuild" {
  name   = "${var.prefix}-pl-build-${local.name}-policy-${local.suffix}"
  role   = aws_iam_role.codepipeline_codebuild.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:StopBuild"
        ],
        Resource : [
          aws_codebuild_project.tf_plan.arn,
          aws_codebuild_project.tf_apply.arn,
        ],
        Effect : "Allow"
      },
      {
        Effect : "Allow",
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : "*"
      }
    ]
  })
}

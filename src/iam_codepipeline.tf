resource "aws_iam_role" "account_cicd_codepipeline" {
  name               = "${var.prefix}-pl-${local.name}-${local.suffix}"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "sts:AssumeRole",
        Principal : {
          Service : "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "account_cicd_codepipeline" {
  name   = "${var.prefix}-pl-${local.name}-policy-${local.suffix}"
  role   = aws_iam_role.account_cicd_codepipeline.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole",
        Resource : aws_iam_role.codepipeline_codecommit.arn,
        Effect : "Allow"
      },
      {
        Action : "sts:AssumeRole",
        Resource : aws_iam_role.codepipeline_codebuild.arn,
        Effect : "Allow"
      },
    ]
  })
}
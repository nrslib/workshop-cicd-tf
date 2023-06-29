resource "aws_iam_role" "codebuild_tf_plan" {
  name               = "${var.prefix}-cb-tfpln-${local.name}-${local.suffix}"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "sts:AssumeRole",
        Principal : {
          Service : "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_tf_plan" {
  name   = "${var.prefix}-pl-tfpln-${local.name}-${local.suffix}"
  role   = aws_iam_role.codebuild_tf_plan.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : "*"
      },
      {
        Effect : "Allow",
        Action : [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        Resource : "*"
      },
      {
        Action : [
          "s3:*"
        ],
        Resource : "*",
        Effect : "Allow"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "codebuild_tf_plan_role" {
  role       = aws_iam_role.codebuild_tf_plan.id
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "codebuild_tf_plan_role_user_define" {
  for_each = toset(var.dest_codebuild_tfplan_policy_arn_list)

  role       = aws_iam_role.codebuild_tf_plan.id
  policy_arn = each.value
}
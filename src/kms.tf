resource "aws_kms_key" "account_cicd_codepipeline_key" {
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.self.account_id}:root"
        },
        Action : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion",
          "kms:GenerateDataKey",
          "kms:TagResource",
          "kms:UntagResource"
        ],
        Resource : "*"
      },
      {
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.self.account_id}:root"
        },
        Action : [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*"
        ],
        Resource : "*"
      },
      {
        Effect : "Allow",
        Principal : {
          AWS : [
            aws_iam_role.codepipeline_codecommit.arn,
            aws_iam_role.codebuild_tf_plan.arn,
            aws_iam_role.codebuild_tf_apply.arn,
          ]
        },
        Action : [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*"
        ],
        Resource : "*"
      },
    ]
  })
}

resource "aws_kms_alias" "account_cicd_codepipeline_key" {
  target_key_id = aws_kms_key.account_cicd_codepipeline_key.id
  name          = "alias/${var.prefix}-pipeline-s3-key-${local.name}-${local.suffix}"
}
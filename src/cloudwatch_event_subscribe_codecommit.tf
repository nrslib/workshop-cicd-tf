resource "aws_cloudwatch_event_rule" "event_subscribe_codecommit" {
  name          = "${var.prefix}-sub-commit-${local.name}-${local.suffix}"
  event_pattern = jsonencode({
    detail-type : [
      "CodeCommit Repository State Change"
    ],
    resources : [
      local.codecommit_arn
    ],
    source : [
      "aws.codecommit"
    ],
    detail : {
      event : [
        "referenceCreated",
        "referenceUpdated"
      ],
      referenceName : [
        var.codecommit_branch_name
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "account_cicd_event_subscribe_codecommit" {
  rule     = aws_cloudwatch_event_rule.event_subscribe_codecommit.id
  arn      = aws_codepipeline.cicd_pipeline.arn
  role_arn = aws_iam_role.cloudwatch_event_subscribe_codecommit.arn
}
locals {
  terraform_id   = "workshop-cicd-tf"
  name           = "${var.codecommit_repository_name}-${replace(var.codecommit_branch_name, "/", "--")}"
  suffix         = substr(lower(sha256("${local.name}-${local.terraform_id}")), 0, 6)
  codecommit_arn = "arn:aws:codecommit:${data.aws_region.self.name}:${data.aws_caller_identity.self.account_id}:${var.codecommit_repository_name}"
}

# Basic
variable "aws_profile" { default = null }
variable "aws_region" { default = "ap-northeast-1" }
variable "git_version" {}
variable "prefix" {}
variable "owner" {}

# Main
variable "codebuild_buildspec_file_name" { default = null }
variable "codecommit_repository_name" {}
variable "codecommit_branch_name" {}
variable "dest_codebuild_tfplan_policy_arn_list" {
  default = []
  type = list(string)
}
variable "dest_codebuild_build_policy_arn_list" {
  default = []
  type = list(string)
}

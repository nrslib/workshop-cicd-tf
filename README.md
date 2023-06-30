# CI/CD terraform

## Command

```shell
terraform init -backend-config={tfbackend-file}

terraform apply \
  -var="aws_profile=999999999999_AWSAdministratorAccess" \
  -var="owner={your-id}" \
  -var="prefix=test" \
  -var="codecommit_repository_name={your-codecommit_repository_name}" \
  -var="dest_codebuild_tfplan_policy_arn_list=[\"arn:aws:iam::aws:policy/PowerUserAccess\"]" \
  -var="dest_codebuild_build_policy_arn_list=[\"arn:aws:iam::aws:policy/AdministratorAccess\"]" \
  -var="codecommit_branch_name=test" \
  -var="git_version=$(git show --format='%H' --no-patch)"
```

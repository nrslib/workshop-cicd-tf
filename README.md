# CI/CD terraform

## Command

```shell
terraform init -backend-config={tfbackend-file}

terraform apply \
  -var="aws_profile=999999999999_AWSAdministratorAccess" \
  -var="owner={your-id}" \
  -var="prefix=test" \
  -var="codecommit_repository_name={your-codec
  -var="dest_codebuild_build_policy_arn_list=[\"arn:aws:iam::aws:policy/AdministratorAccess\"]" \ommit_repository_name}" \
  -var="codecommit_branch_name=test" \
  -var="git_version=$(git show --format='%H' --no-patch)"
```

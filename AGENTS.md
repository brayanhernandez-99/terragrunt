# AGENTS.md — infrastructure-as-code-invictus

## What this is

AWS multi-account Terraform monorepo managed by **Terragrunt**. 42 module types under `iac-template-terraform/modules/aws/`, called by 523+ `terragrunt.hcl` stacks under `iac-terragrunt/invictus/`. Azure DevOps CI/CD with external pipeline template.

## Critical: Placeholder substitution

All environment/account-specific values use `#{variable_name}#` syntax (e.g. `#{aws_bucket}#`, `#{aws_region}#`, `#{aws_environment}#`). These are **resolved by the CI/CD pipeline** — the external template at `DevOps-templates-UX/pipelines-templates` (branch `feature/infrastructure-as-code`). Terragrunt/Terraform **never** resolves them. Running terragrunt locally without substitution will produce broken configs with literal placeholder strings.

## Layout

```
iac-template-terraform/modules/aws/   → 42 reusable Terraform modules (source of truth)
iac-terragrunt/invictus/              → 48 deployable stack directories
  root.hcl                            → global generate blocks for provider.tf + backend.tf
  initial-infrastructure/             → VPC, ECS cluster, RDS, DynamoDB, shared infra
  apps/                               → CloudFront, S3 buckets, cache policies (cross-cutting)
  {45+ microservice directories}/     → per-service stacks (ECS, SSM, SQS, S3, IAM, etc.)
pipeline/main-pipeline.yml            → Azure DevOps pipeline entrypoint (delegates to external template)
```

## Module sourcing

All terragrunt configs use local paths:
```hcl
source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-<type>"
```
The repo must be fully cloned — no registry fetching.

## Generated files

`root.hcl` auto-generates `provider.tf` and `backend.tf` in each directory via `generate` blocks. Do not edit these manually.

## State

S3 backend — key derived from `path_relative_to_include()`. Each terragrunt module gets its own state file.

## Environments

| Branch    | Environment |
|-----------|-------------|
| `develop` | dev         |
| `staging` | staging     |
| `master`  | production  |

Pushes/PRs on only these three branches trigger the pipeline.

## Commands

Standard Terragrunt workflow — no custom scripts/Makefiles in-repo:

| Task                          | Command                                    |
|-------------------------------|--------------------------------------------|
| Init a single module          | `terragrunt init`                          |
| Plan a single module          | `terragrunt plan`                          |
| Plan all modules              | `terragrunt run-all plan`                  |
| Apply all                     | `terragrunt run-all apply`                 |
| Format modules                | `terraform fmt -recursive` (from repo root)|
| Validate                      | `terraform validate`                       |

## Git remotes

| Remote | URL |
|--------|-----|
| `origin` | `git@ssh.dev.azure.com:v3/ux-technology/Invictus-Infrastructure/infrastructure-as-code-invictus` 

## What's NOT in this repo

- No tests (no terraform test, Terratest, or any test framework)
- No linters/formatter config (tflint, tfsec, checkov, pre-commit)
- No Makefile / Taskfile / scripts
- No existing instruction files (this is the first)

## Gotchas

- `dependency` blocks use `mock_outputs` — plans without state will use mock values.
- All ECS services use Fargate + `awsvpc` network mode.
- CloudWatch logs retention is 30d.
- AWS provider pinned to `~> 6.8.0`.
- Each microservice typically has subdirectories per resource type (ECS, SSM, SQS, S3, IAM, Secrets Manager, EventBridge).

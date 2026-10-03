# terraform-production-starter

A production-ready Terraform layout for AWS: reusable modules, one state per
environment, pinned versions, consistent naming and tagging, lint/security
scanning, policy checks and a GitHub Actions pipeline (plan on PR, apply the
reviewed plan on merge, approval gate for prod, nightly drift detection).

## Quick start (Ubuntu)

```bash
./scripts/install-tools-ubuntu.sh      # terraform, tflint, trivy, checkov, ...
aws configure sso                      # or any way you get AWS credentials

# 1. One-time: create the state bucket + GitHub OIDC roles
cd bootstrap
terraform init && terraform apply

# 2. Put the bucket name into environments/*/backend.tf, then:
cd ../environments/dev
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Layout

| Path | Purpose |
|------|---------|
| `bootstrap/` | State bucket + CI roles (applied once, by hand) |
| `modules/` | Reusable modules (network, s3-bucket) |
| `environments/<env>/` | Root configs, one state per environment |
| `policy/` | OPA/Conftest policies run against the plan |
| `.github/workflows/` | CI/CD: checks, plan, apply, drift |

Run `make help` to see the day-to-day commands.

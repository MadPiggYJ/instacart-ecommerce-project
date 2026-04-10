# Data Lake: AWS Glue + Athena (Instacart Dataset)

A Data Lake project using Terraform to provision AWS infrastructure for querying Instacart e-commerce data via Glue Data Catalog and Athena.

## Architecture

```
Raw CSV Data (local)
      │
      ▼
  S3 (raw/)          ← Terraform uploads CSVs on apply
      │
      ▼
AWS Glue Data Catalog  ← External tables defined via Terraform
      │
      ▼
  AWS Athena         ← Query raw data using SQL
```

**AWS Resources:**
- S3 bucket — raw data storage (`datalake-instacart-ecommerce-dev-data-<account_id>`)
- S3 bucket — Athena query results (`datalake-instacart-ecommerce-dev-athena-results-<account_id>`)
- Glue Database + External Tables (aisles, departments, orders, products, order_products_prior)
- Athena Workgroup

**Terraform Remote State:**
- Backend: S3 (`tf-lock-s3-20260218`)
- Lock: DynamoDB (`terraform-lock-table`)
- Region: `ap-southeast-2`

## Dataset

[Instacart Market Basket Analysis](https://www.kaggle.com/competitions/instacart-market-basket-analysis) — grocery order data.

| File | Description |
|------|-------------|
| `aisles.csv` | Aisle IDs and names |
| `departments.csv` | Department IDs and names |
| `orders.csv` | Order metadata per user |
| `products.csv` | Product details |
| `order_products__prior.csv.gz` | Prior order items (large, gzip) |

> Note: `*.gz` files are excluded from Git. Place them in `data/` locally before running `terraform apply`.

## Prerequisites

- Terraform >= 1.6
- AWS CLI configured, or OIDC role for GitHub Actions
- Existing S3 bucket and DynamoDB table for Terraform remote state

## Local Usage

```bash
cd Infra/environments/dev

terraform init
terraform plan
terraform apply
```

## CI/CD (GitHub Actions)

The workflow at [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml) runs on every push to `main`.

**Pipeline steps:**
1. Checkout code
2. Authenticate to AWS via OIDC (no long-lived credentials)
3. `terraform init`
4. `terraform fmt -check`
5. `terraform validate`
6. `terraform plan`
7. `terraform apply -auto-approve`

### GitHub Secrets / OIDC Setup

This project uses **AWS OIDC** — no AWS access keys are stored in GitHub.

1. Create an IAM Role with a trust policy for GitHub Actions OIDC:
   ```json
   {
     "Effect": "Allow",
     "Principal": {
       "Federated": "arn:aws:iam::<account_id>:oidc-provider/token.actions.githubusercontent.com"
     },
     "Action": "sts:AssumeRoleWithWebIdentity",
     "Condition": {
       "StringLike": {
         "token.actions.githubusercontent.com:sub": "repo:<your-github-org>/<your-repo>:*"
       }
     }
   }
   ```

2. Update the role ARN in [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml):
   ```yaml
   role-to-assume: arn:aws:iam::<account_id>:role/github-actions-terraform-role
   ```

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions CI/CD
├── data/                       # Raw CSV data files
│   ├── aisles.csv
│   ├── departments.csv
│   ├── orders.csv
│   ├── products.csv
│   └── order_products__prior.csv.gz  # (gitignored, large file)
└── Infra/
    └── environments/
        └── dev/
            ├── main.tf         # Provider config
            ├── backend.tf      # S3 remote state
            ├── locals.tf       # Shared locals
            ├── var.tf          # Variables
            ├── s3.tf           # S3 buckets + data upload
            ├── glue.tf         # Glue DB + external tables
            ├── athena.tf       # Athena workgroup
            ├── outputs.tf
            └── modules/
                ├── s3/
                ├── athena/
                └── vpc/
```

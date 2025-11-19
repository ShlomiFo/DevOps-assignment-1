# Minimal AWS EKS (Terraform) — minimal + S3 backend (C1)

## What this creates
- VPC with 2 subnets (public, private)
- ECR repository
- EKS cluster
- 2 Managed EKS Node Groups (one per subnet)
- IAM roles/policies required for EKS

## Pre-requisites
- Terraform >= 1.4
- AWS CLI configured or environment creds
- An S3 bucket and DynamoDB table for Terraform state (see below)

## Backend (S3) setup
You must create an S3 bucket and a DynamoDB table for state locking BEFORE running `terraform init` with the S3 backend.

Example (using AWS CLI):
```bash
aws s3api create-bucket --bucket my-terraform-state-bucket-12345 --region us-east-1
aws dynamodb create-table --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST --region us-east-1


# This project creates :

Provision an AWS EKS cluster using Terraform .

Containerize a FLASK application using Docker.

Deploy the application using Helm.

Automate the deploymeny using Jenkins.



## Step 1: AWS Setup (Before Running Terraform)

Before deploying the infrastructure, configure your AWS CLI and create the S3 bucket + DynamoDB table that Terraform will use for remote state storage.

### 1. Configure AWS CLI

Make sure your AWS credentials are set:

```bash
aws configure

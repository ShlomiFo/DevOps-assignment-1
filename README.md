
# This project :

Provision an AWS EKS cluster using Terraform .

Containerize a FLASK application using Docker.

Deploys the application using Helm.

Automates the deploymeny using Jenkins.



## Step 1: AWS Setup (Before Running Terraform)

Before deploying the infrastructure, configure your AWS CLI and create the S3 bucket + DynamoDB table that Terraform will use for remote state storage.

### 1. Configure AWS CLI and setup S3 bucket

Make sure your AWS credentials are set:

```bash
aws configure

log in with your admin creadentials
'''

### 2.  Backend (S3) setup

You must create an S3 bucket and a DynamoDB table for state locking BEFORE running `terraform init` with the S3 backend.

Example (using AWS CLI):
```bash
aws s3api create-bucket --bucket terraform-state-bucket-113 --region us-east-1
aws dynamodb create-table --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST --region us-east-1

## Step 2: Running Terraform:

### 1. terraform init
### 2. terraform plan
### 3. terraform apply.

The apply stage could take several minutes.

## step 3: Build Docker Image and push it to your AWS registry

### 1. From the CLI, go to the /app directory.

### 2. Run the command Docker build
Docker buildx build . -t {your app name and version}

### 3. Push to your AWS ECR

#### 1. Create IAM user with ECR policy, use these comands in the AWS CLI,:

    aws iam create-user --user-name YourECRUser

    aws iam attach-user-policy --user-name <your-user-name> --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess

Create secretKey:

aws iam create-access-key --user-name <your-user-name>

The output of this command will include the SecretAccessKey. This is the only time you will be able to view it, so save it in a secure location

#### 2. Configure your AWS ECR user creadentials:

''' bash
AWS configure
'''

login with your ECR user creadentials.

#### 3. Push your docker image to your AWS registry with the following commands:

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 487509570044.dkr.ecr.us-east-1.amazonaws.com

docker tag
<your app tag> 487509570044.dkr.ecr.us-east-1.amazonaws.com/demo-app-repo:latest

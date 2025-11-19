terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-113"         # e.g. my-terraform-state-bucket-123
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks" # e.g. terraform-locks
    encrypt        = true
  }
}

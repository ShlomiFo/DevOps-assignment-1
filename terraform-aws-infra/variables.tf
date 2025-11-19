variable "region" {
  type    = string
  default = "us-east-1"
}

variable "name_prefix" {
  type    = string
  default = "demo"
}

variable "aws_profile" {
  description = "AWS CLI profile to use for the AWS provider"
  type        = string
  default     = "default"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a"]
}

variable "node_groups" {
  type = list(object({
    desired_size   = number
    max_size       = number
    min_size       = number
    instance_types = list(string)
  }))

  default = [
    {
      desired_size   = 1
      min_size       = 1
      max_size       = 2
      instance_types = ["t3.medium"]
    },
    {
      desired_size   = 1
      min_size       = 1
      max_size       = 2
      instance_types = ["t3.medium"]
    }
  ]
}

variable "tags" {
  type = map(string)
  default = {
    Owner = "terraform"
  }
}

variable "name" { type = string }
variable "cidr" { type = string }
variable "public_cidr" { type = string }
variable "private_cidr" { type = string }

variable "azs" {
  default  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  type     = list(string)
}
variable "tags" { type = map(string) }

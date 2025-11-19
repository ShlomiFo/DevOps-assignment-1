variable "name" { type = string }
variable "cidr" { type = string }
variable "public_cidr" { type = string }
variable "private_cidr" { type = string }
variable "azs" { type = list(string) }
variable "tags" { type = map(string) }

variable "cluster_name" { type = string }
variable "subnet_ids" { type = list(string) }

variable "node_groups" {
  type = list(object({
    desired_size   = number
    max_size       = number
    min_size       = number
    instance_types = list(string)
  }))
}

variable "tags" { type = map(string) }

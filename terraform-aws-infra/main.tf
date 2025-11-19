locals {
  name_prefix = var.name_prefix
}

module "vpc" {
  source         = "./modules/vpc"
  name           = local.name_prefix
  cidr           = var.vpc_cidr
  public_cidr    = var.public_subnet_cidr
  private_cidr   = var.private_subnet_cidr
  azs            = var.azs
  tags           = var.tags
}

module "ecr" {
  source = "./modules/ecr"
  name   = "${local.name_prefix}-app-repo"
  tags   = var.tags
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = "${local.name_prefix}-eks"
  subnet_ids   = [module.vpc.public_subnet_id, module.vpc.private_subnet_id]
  node_groups  = var.node_groups
  tags         = var.tags
}

module "network" {
  source = "../../modules/network"

  name                 = local.name_prefix
  cidr_block           = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  single_nat_gateway   = var.single_nat_gateway
}

module "logs_bucket" {
  source = "../../modules/s3-bucket"

  # Account ID suffix keeps the globally-unique name predictable.
  bucket_name = "${local.name_prefix}-logs-${var.aws_account_id}"

  tags = { Component = "logging" }
}

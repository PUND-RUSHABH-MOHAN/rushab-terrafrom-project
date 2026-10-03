# network module

Creates a VPC with public and private subnets across multiple AZs,
an internet gateway, NAT gateway(s) and route tables. The default
security group is locked down (no rules).

## Usage

```hcl
module "network" {
  source = "../../modules/network"

  name                 = "billing-prod"
  cidr_block           = "10.20.0.0/16"
  azs                  = ["ap-south-1a", "ap-south-1b"]
  public_subnet_cidrs  = ["10.20.0.0/24", "10.20.1.0/24"]
  private_subnet_cidrs = ["10.20.10.0/24", "10.20.11.0/24"]
  single_nat_gateway   = false
}
```

<!-- BEGIN_TF_DOCS -->
<!-- terraform-docs fills this section: run `make docs` -->
<!-- END_TF_DOCS -->

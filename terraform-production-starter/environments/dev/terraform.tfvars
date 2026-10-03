# Non-secret values only. Secrets come from a secrets manager, never tfvars.
project        = "billing"
environment    = "dev"
region         = "ap-south-1"
aws_account_id = "123456789012"
owner          = "platform-team"
cost_center    = "cc-1042"

vpc_cidr             = "10.10.0.0/16"
azs                  = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs  = ["10.10.0.0/24", "10.10.1.0/24"]
private_subnet_cidrs = ["10.10.10.0/24", "10.10.11.0/24"]
single_nat_gateway   = true # one NAT to save cost

# Non-secret values only. Secrets come from a secrets manager, never tfvars.
project        = "billing"
environment    = "prod"
region         = "ap-south-1"
aws_account_id = "123456789012"
owner          = "platform-team"
cost_center    = "cc-1042"

vpc_cidr             = "10.20.0.0/16"
azs                  = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs  = ["10.20.0.0/24", "10.20.1.0/24"]
private_subnet_cidrs = ["10.20.10.0/24", "10.20.11.0/24"]
single_nat_gateway   = false # one NAT per AZ for HA

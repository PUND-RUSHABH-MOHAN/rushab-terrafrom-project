# Run from modules/network:  terraform init -backend=false && terraform test
# mock_provider means no AWS credentials and no real resources are needed.
mock_provider "aws" {}

variables {
  name                 = "test"
  cidr_block           = "10.0.0.0/16"
  azs                  = ["ap-south-1a", "ap-south-1b"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
}

run "creates_one_subnet_per_az" {
  command = plan

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Expected one public subnet per AZ."
  }

  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "Expected one private subnet per AZ."
  }
}

run "single_nat_gateway_by_default" {
  command = plan

  assert {
    condition     = length(aws_nat_gateway.this) == 1
    error_message = "single_nat_gateway = true should create exactly one NAT."
  }
}

run "one_nat_per_az_when_ha" {
  command = plan

  variables {
    single_nat_gateway = false
  }

  assert {
    condition     = length(aws_nat_gateway.this) == 2
    error_message = "Expected one NAT gateway per AZ."
  }
}

run "rejects_invalid_cidr" {
  command = plan

  variables {
    cidr_block = "not-a-cidr"
  }

  expect_failures = [var.cidr_block]
}

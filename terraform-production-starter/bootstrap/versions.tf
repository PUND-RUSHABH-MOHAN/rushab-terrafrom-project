terraform {
  required_version = ">= 1.10.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Bootstrap uses LOCAL state on purpose (the bucket does not exist yet).
  # After the first apply you can migrate it: add a backend "s3" block
  # pointing at the new bucket and run: terraform init -migrate-state
}

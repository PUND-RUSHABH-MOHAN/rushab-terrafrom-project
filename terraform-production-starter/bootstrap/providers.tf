provider "aws" {
  region              = var.region
  allowed_account_ids = [var.aws_account_id]

  default_tags {
    tags = {
      Project     = "platform"
      Environment = "shared"
      Owner       = "platform-team"
      ManagedBy   = "terraform"
      CostCenter  = "platform"
    }
  }
}

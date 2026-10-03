provider "aws" {
  region = var.region

  # Refuse to run against the wrong account (a classic prod accident).
  allowed_account_ids = [var.aws_account_id]

  # Every taggable AWS resource inherits these tags automatically.
  default_tags {
    tags = local.common_tags
  }
}

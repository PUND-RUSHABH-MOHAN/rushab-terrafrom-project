variable "region" {
  description = "AWS region for the state bucket"
  type        = string
  default     = "ap-south-1"
}

variable "aws_account_id" {
  description = "AWS account ID Terraform is allowed to touch"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id must be a 12-digit AWS account ID."
  }
}

variable "state_bucket_name" {
  description = "Globally unique name of the S3 bucket that stores state"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository allowed to assume the CI roles (org/repo)"
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$", var.github_repo))
    error_message = "github_repo must look like \"my-org/my-repo\"."
  }
}

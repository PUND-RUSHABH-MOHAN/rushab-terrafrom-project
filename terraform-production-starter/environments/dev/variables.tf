variable "project" {
  description = "Short project name used in resource names, e.g. billing"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,20}$", var.project))
    error_message = "project must be lowercase letters, digits and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging or prod."
  }
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "The only AWS account this configuration may modify"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id must be a 12-digit AWS account ID."
  }
}

variable "owner" {
  description = "Team that owns these resources (used in tags)"
  type        = string
}

variable "cost_center" {
  description = "Cost center for billing reports (used in tags)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones to use"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs, one per AZ"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs, one per AZ"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "true = one shared NAT (cheap), false = one NAT per AZ (HA)"
  type        = bool
}

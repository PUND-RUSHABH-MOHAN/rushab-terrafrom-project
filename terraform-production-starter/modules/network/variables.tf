variable "name" {
  description = "Name prefix for all network resources, e.g. billing-prod"
  type        = string
}

variable "cidr_block" {
  description = "IPv4 CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "cidr_block must be a valid IPv4 CIDR, e.g. 10.0.0.0/16."
  }
}

variable "azs" {
  description = "Availability zones to spread subnets across"
  type        = list(string)

  validation {
    condition     = length(var.azs) >= 2
    error_message = "Use at least two availability zones for resilience."
  }
}

variable "public_subnet_cidrs" {
  description = "One public subnet CIDR per AZ, in the same order as azs"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.azs)
    error_message = "Provide exactly one public subnet CIDR per AZ."
  }
}

variable "private_subnet_cidrs" {
  description = "One private subnet CIDR per AZ, in the same order as azs"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.azs)
    error_message = "Provide exactly one private subnet CIDR per AZ."
  }
}

variable "enable_nat_gateway" {
  description = "Create NAT gateway(s) so private subnets can reach the internet"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use one shared NAT gateway (cheaper) instead of one per AZ (HA)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Extra tags for every resource (on top of provider default_tags)"
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "Globally unique bucket name"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name: 3-63 chars of a-z, 0-9, dots, hyphens."
  }
}

variable "enable_versioning" {
  description = "Keep previous versions of objects"
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Delete old object versions after this many days"
  type        = number
  default     = 90
}

variable "force_destroy" {
  description = "Allow terraform destroy to delete a non-empty bucket (never in prod)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Extra tags for the bucket"
  type        = map(string)
  default     = {}
}

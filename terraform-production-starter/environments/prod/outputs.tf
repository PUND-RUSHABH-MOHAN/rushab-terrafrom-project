output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs for workloads"
  value       = module.network.private_subnet_ids
}

output "logs_bucket_name" {
  description = "Name of the logs bucket"
  value       = module.logs_bucket.id
}

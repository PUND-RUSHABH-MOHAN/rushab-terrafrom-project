# State for this environment only. Bucket is created by ../../bootstrap.
# use_lockfile = native S3 locking (Terraform >= 1.10, no DynamoDB needed).
terraform {
  backend "s3" {
    bucket       = "mycompany-terraform-state-123456789012"
    key          = "dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}

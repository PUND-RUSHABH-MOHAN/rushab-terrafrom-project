# s3-bucket module

A private S3 bucket with secure defaults: public access blocked, ACLs
disabled, encryption at rest, versioning and lifecycle cleanup.

```hcl
module "logs_bucket" {
  source      = "../../modules/s3-bucket"
  bucket_name = "billing-prod-logs-123456789012"
}
```

<!-- BEGIN_TF_DOCS -->
<!-- terraform-docs fills this section: run `make docs` -->
<!-- END_TF_DOCS -->

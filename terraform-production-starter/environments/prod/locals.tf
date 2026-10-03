locals {
  # Naming pattern: {project}-{environment}-{component}
  name_prefix = "${var.project}-${var.environment}"

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
    ManagedBy   = "terraform"
    Repository  = "github.com/mycompany/terraform-production-starter"
  }
}

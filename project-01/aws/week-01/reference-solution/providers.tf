
provider "aws" {
  region = var.aws_region

  # Automatically applies these tags to all supported AWS resources
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      Owner       = var.owner
      ManagedBy   = "Terraform"
    }
  }
}
terraform {
  # 1. Enforce the required Terraform CLI version
  required_version = ">= 1.5"

  # 2. Declare and restrict provider plugin versions
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

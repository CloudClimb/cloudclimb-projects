variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "The environment to deploy resources in"
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "cloudclimb-project01"
}

variable "owner" {
  type        = string
  description = "The owner of the resources"
  default     = "Mehdi"
}

variable "vpc_cidr" {
  type        = string
  description = "The IP address range for the whole VPC"
  default     = "10.0.0.0/16"
}

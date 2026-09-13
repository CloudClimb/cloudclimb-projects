# Azure Week 01 Reference Solution

This folder contains the reference deployment for Project 01 - Week 01 in Azure.

The purpose of this deployment is to provide a working example of how the Week 01 requirements can be completed using Terraform.

## What This Deployment Covers

Week 01 focuses on building the base Azure environment that the rest of the project will build on.

This reference solution includes:

- Azure Resource Group
- Virtual Network
- Application Subnet
- Data Subnet
- Network Security Group
- Resource tagging
- Terraform variables
- Terraform outputs
- Basic Azure provider configuration

## Files

```text
week-01/
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

## main.tf

Contains the Azure resources used for the Week 01 deployment.

## variables.tf

Defines the variables used throughout the Terraform configuration.

## outputs.tf

Displays useful information from the deployment such as resource names and IDs.

## Deployment

From the `azure/week-01` directory, run:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

After the deployment completes, view the outputs with:

```bash
terraform output
```

## Validation

The reference deployment should successfully:

- Pass `terraform validate`
- Complete `terraform plan` without errors
- Complete `terraform apply`
- Create the expected resources in Azure
- Return the configured Terraform outputs

## Notes

This is a reference solution, not the only correct way to complete Week 01.

Participants may structure their Terraform differently as long as their deployment meets the Week 01 requirements and acceptance criteria.

This solution will be released after Week 01 is completed so participants can compare their deployment against a working example.

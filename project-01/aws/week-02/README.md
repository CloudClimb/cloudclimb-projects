# Project 01 - AWS Week 02
## Application Compute, Network Integration, and Troubleshooting

Welcome to Week 02 of Project 01.

In Week 01, you built the AWS network foundation that the rest of this project will use.

You should already have:

- 1 VPC
- 2 Application Subnets across 2 Availability Zones
- 2 Data Subnets across 2 Availability Zones
- 2 Management Subnets across 2 Availability Zones
- Internet Gateway
- Public and private route tables
- Security Groups
- Consistent naming
- Resource tags
- Basic architecture documentation

This week, you will build directly on top of that environment.

The goal of Week 02 is to add the first application compute resource to the network you already created, secure the way that resource is accessed, and work through a small troubleshooting scenario.

Memos will **not** be fully deployed yet.

This week is about preparing the infrastructure that Memos will run on during the next stage of the project.

---

# Scenario

The networking foundation has been completed.

The application team is now ready for compute capacity that can eventually host the Memos application.

Your task is to deploy a Linux workload host into the existing application tier, make sure it is connected to the correct network, restrict unnecessary access, verify that it can communicate as expected, and troubleshoot a connectivity problem without rebuilding the environment.

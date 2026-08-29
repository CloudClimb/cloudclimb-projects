# Week 1 - Build the AWS Network Foundation

## Scenario

CloudClimb is preparing to deploy **Memos**, an open-source self-hosted note-taking application.

Before the application can be deployed, the cloud engineering team needs to build the AWS network foundation that will support the application, database, and management resources as Project 01 grows.

You are **not deploying Memos during Week 1**.

Your task is to design and deploy the AWS network that Memos will eventually live inside.

---

## Objective

Create a segmented AWS network that can support:

- Application resources
- Database/backend resources
- Management/administrative resources

The goal is to build a foundation that will continue to be used throughout Project 01.

This is not a disposable lab.

---

## Requirements

Your AWS environment must include:

- One VPC
- An application subnet
- A data/backend subnet
- A management subnet
- A documented CIDR/IP addressing plan
- Appropriate route tables and routing
- Network-level security controls
- Consistent resource naming
- Project/environment tags
- A simple architecture diagram

You may add additional network components if your design requires them.

---

## AWS Services

You will likely work with:

- Amazon VPC
- Subnets
- Route Tables
- Security Groups
- Resource Tags

You may also consider services such as:

- Internet Gateway
- Network ACLs
- NAT Gateway

Only add additional services if your architecture actually requires them.

Do not deploy resources simply because they are available.

Be prepared to explain why each major resource exists.

---

## Network Design

At minimum, your VPC should contain three logical network segments:

### Application Subnet

This subnet will eventually support the Memos application or related application resources.

### Data Subnet

This subnet will eventually support the Memos database or backend resources.

Design this subnet with private database access in mind.

### Management Subnet

This subnet is reserved for management or administrative resources that may be introduced later in the project.

---

## CIDR Planning

You are responsible for choosing and documenting your own valid CIDR ranges.

Example only:

```text
VPC:                10.10.0.0/16
Application Subnet: 10.10.1.0/24
Data Subnet:        10.10.2.0/24
Management Subnet:  10.10.3.0/24

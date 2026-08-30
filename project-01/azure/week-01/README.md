# Week 1 - Build the Azure Network Foundation

## Scenario

CloudClimb is preparing to deploy **Memos**, an open-source self-hosted note-taking application.

Later in Project 01, Memos will connect to a separate **PostgreSQL database using Azure Database for PostgreSQL**.

Before any application, database, or compute resources are deployed, the cloud engineering team needs to build the Azure network foundation that will support the environment throughout the project.

You are **not deploying Memos, PostgreSQL, compute resources, or an application entry point during Week 1**.

Your task is to design and deploy the Azure network that those resources will eventually use.

---

## Objective

Create a segmented Azure network that can later support:

- Application resources
- Private database/backend resources
- Private management/administrative resources
- Future public application access at the resource or service level

The network created this week will continue to be used and expanded throughout Project 01.

This is not a disposable lab.

---

## Requirements

Your Azure environment must include:

- One Resource Group
- One Virtual Network
- One application subnet
- One data/backend subnet
- One management subnet
- Network Security Groups
- Appropriate routing
- A documented CIDR/IP addressing plan
- Consistent resource naming
- Project/environment tags
- A simple architecture diagram

Your subnet ranges must not overlap.

---

## Why Azure Uses One Subnet Per Tier

Azure networking works differently from AWS.

In AWS, a subnet exists inside a single Availability Zone. Because of that, the AWS track uses multiple subnets across multiple Availability Zones.

Azure subnets are **regional** and are not tied to one Availability Zone.

Because of this, the Azure track does not need duplicate subnets such as:

```text
app-zone-1
app-zone-2
data-zone-1
data-zone-2
The goal is to build a foundation that will continue to be used throughout Project 01.

This is not a disposable lab.

---

## Requirements

Your Azure environment must include:

- One Resource Group for Project 01 resources
- One Virtual Network
- An application subnet
- A data/backend subnet
- A management subnet
- A documented CIDR/IP addressing plan
- Appropriate routing
- Network-level security controls
- Consistent resource naming
- Project/environment tags
- A simple architecture diagram

You may add additional network components if your design requires them.

---

## Azure Services

You will likely work with:

- Resource Groups
- Virtual Networks
- Subnets
- Network Security Groups
- Resource Tags

You may also consider services such as:

- Route Tables / User Defined Routes
- NAT Gateway
- Azure Bastion
- Azure Firewall

Only add additional services if your architecture actually requires them.

Do not deploy resources simply because they are available.

Be prepared to explain why each major resource exists.

---

## Network Design

At minimum, your Virtual Network should contain three logical network segments:

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
VNet:               10.10.0.0/16
Application Subnet: 10.10.1.0/24
Data Subnet:        10.10.2.0/24
Management Subnet:  10.10.3.0/24

# Week 1 - Build the AWS Network Foundation

## Scenario

CloudClimb is preparing to deploy **Memos**, an open-source self-hosted note-taking application.

Later in Project 01, Memos will connect to a separate **PostgreSQL database using Amazon RDS**.

Before any application, database, or compute resources are deployed, the cloud engineering team needs to build the AWS network foundation that will support the environment throughout the project.

You are **not deploying Memos, RDS, compute resources, or a load balancer during Week 1**.

Your task is to design and deploy the AWS network that those resources will eventually use.

---

## Objective

Create a segmented AWS network across two Availability Zones that can later support:

- Public application resources
- Private database/backend resources
- Private management/administrative resources

The network created this week will continue to be used and expanded throughout Project 01.

This is not a disposable lab.

---

## Requirements

Your AWS environment must include:

- One VPC
- At least two Availability Zones
- Two public application subnets, one in each Availability Zone
- Two private data/backend subnets, one in each Availability Zone
- Two private management subnets, one in each Availability Zone
- One Internet Gateway
- Appropriate route tables and routing
- Network-level security controls
- A documented CIDR/IP addressing plan
- Consistent resource naming
- Project/environment tags
- A simple architecture diagram

Your subnet ranges must not overlap.

---

## Why Two Availability Zones?

In AWS, a subnet exists inside a single Availability Zone.

Later in Project 01, we plan to introduce services that require or benefit from networking across multiple Availability Zones.

For example:

- An Application Load Balancer requires subnets across multiple Availability Zones
- Amazon RDS uses a DB subnet group containing subnets across multiple Availability Zones

Designing the network across two Availability Zones now helps avoid having to redesign the VPC and IP addressing plan later.

---

## Planned Network Layout

Your Week 1 network should follow this general structure:

```text
VPC
│
├── Availability Zone A
│   ├── App-A          Public
│   ├── Data-A         Private
│   └── Management-A   Private
│
└── Availability Zone B
    ├── App-B          Public
    ├── Data-B         Private
    └── Management-B   Private

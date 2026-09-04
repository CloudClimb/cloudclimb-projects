# Project 01 - CloudClimb Memos Deployment

Project 01 is CloudClimb's first full hands-on cloud engineering project.

The goal is to build and improve one cloud environment over multiple weeks instead of completing a series of disconnected labs.

Throughout the project, participants will design, deploy, secure, automate, monitor, and troubleshoot infrastructure for **Memos**, an open-source self-hosted note-taking application.

AWS and Azure participants will follow the same overall business scenario while using services that make sense for their chosen cloud platform.

---

## Project Scenario

A company wants to deploy a lightweight internal web application in the cloud.

The application selected for this project is **Memos**, an open-source self-hosted note-taking platform.

The cloud engineering team is responsible for building the environment from the ground up and improving it over time.

The project will cover areas such as:

- Cloud networking
- Application hosting
- Containers
- Database connectivity
- Security controls
- Identity and access
- Monitoring and logging
- Troubleshooting
- Infrastructure as Code
- Git and GitHub workflows
- CI/CD
- Documentation
- Cost awareness

Each week will build on the infrastructure created during the previous week.

This is not a collection of separate labs.

The goal is to continue improving the same environment until Memos is running on a complete cloud-hosted application platform.

---

## About Memos

**Memos** is a lightweight, open-source, self-hosted note-taking application.

It gives Project 01 a real workload to build infrastructure around without requiring participants to develop an application themselves.

Participants are not expected to modify the Memos source code.

The focus of Project 01 is the infrastructure required to deploy, secure, operate, automate, and support the application.

Memos gives us a workload that can be used to practice concepts such as:

- Containers
- Application networking
- Databases
- Environment variables
- Secrets
- Access controls
- Monitoring
- Logging
- CI/CD
- Infrastructure automation

---

# Project Architecture

Project 01 will follow a simple multi-tier architecture.

The major parts of the environment will include:

```text
Users
  |
  v
Application Tier
  |
  v
Database Tier
```

Additional networking, security, management, monitoring, and automation components will be added throughout the project.

The final architecture will not be identical between AWS and Azure.

Each platform should solve the same underlying engineering requirements using the services that are appropriate for that cloud provider.

---

# Database

Project 01 will use a separate PostgreSQL database instead of storing application data inside the Memos container.

The planned database services are:

| Platform | Database |
| --- | --- |
| AWS | Amazon RDS for PostgreSQL |
| Azure | Azure Database for PostgreSQL |

Using PostgreSQL gives the project a real backend service and allows participants to work with:

- Private database networking
- Application-to-database connectivity
- Credentials and secrets
- Security rules
- Persistent application data
- Managed database services

SQLite inside the Memos container is not the planned database architecture for Project 01.

---

# Supported Platforms

Project 01 currently supports:

- AWS
- Azure

Both tracks follow the same business scenario and project goals.

The exact architecture and services may differ between platforms.

For example:

| Requirement | AWS | Azure |
| --- | --- | --- |
| Primary network | VPC | Virtual Network |
| Network security | Security Groups | Network Security Groups |
| Identity and access | IAM | Azure RBAC / Entra ID |
| Managed PostgreSQL | Amazon RDS for PostgreSQL | Azure Database for PostgreSQL |
| Monitoring | CloudWatch | Azure Monitor |
| Infrastructure as Code | Terraform | Terraform |
| CI/CD | GitHub Actions | GitHub Actions |

The goal is not to make AWS and Azure identical.

The goal is to solve the same engineering problem using the services that make sense on each platform.

---

# How Project 01 Works

Project 01 is released in weekly stages.

Each week introduces new requirements that build on the environment from the previous week.

Participants should avoid tearing down and rebuilding completely different environments every week unless instructed to do so.

The infrastructure created during Week 01 becomes the foundation for the rest of the project.

A typical progression will look like:

```text
Week 01
Networking Foundation
      |
      v
Week 02
Compute / Application Infrastructure
      |
      v
Week 03
Memos + PostgreSQL
      |
      v
Week 04
CI/CD + Infrastructure Automation
      |
      v
Week 05
Monitoring + Operations
```

Additional hardening, troubleshooting, cost review, or cleanup work may also be introduced as the project develops.

---

# Week 01 - Network Foundation

Week 01 focuses on designing and deploying the network foundation that will support the rest of Project 01.

Memos is **not deployed during Week 01**.

The goal is to create the base environment that later application and database resources will use.

## AWS

The AWS environment will use one VPC across two Availability Zones.

The Week 01 AWS design includes:

- 1 VPC
- 2 Availability Zones
- 2 Application subnets
- 2 Data subnets
- 2 Management subnets
- Route table configuration
- Network security controls
- Naming standards
- Resource tagging
- Basic architecture documentation

The subnet layout is designed to support services introduced later in the project, including load balancing and Amazon RDS.

Example layout:

```text
VPC

Availability Zone A
├── Application Subnet A
├── Data Subnet A
└── Management Subnet A

Availability Zone B
├── Application Subnet B
├── Data Subnet B
└── Management Subnet B
```

---

## Azure

The Azure environment will use one Resource Group and one Virtual Network.

The Week 01 Azure design includes:

- 1 Resource Group
- 1 Virtual Network
- 1 Application subnet
- 1 Data subnet
- 1 Management subnet
- Network Security Groups
- Naming standards
- Resource tagging
- Basic architecture documentation

Example layout:

```text
Resource Group
└── Virtual Network
    ├── Application Subnet
    ├── Data Subnet
    └── Management Subnet
```

Unlike AWS Availability Zones, Azure participants are not required to create duplicate subnets for each zone during Week 01.

---

# Week 01 Cost Guardrails

Week 01 is intentionally focused on low-cost networking resources.

Participants should **not deploy unnecessary paid services during Week 01**.

Week 01 does not require:

- Application compute
- Memos
- PostgreSQL
- Load balancers
- NAT Gateway
- Other unnecessary paid services

Cost should remain little to nothing for most participants during the first stage of the project.

Participants should always review cloud pricing before deploying additional resources.

---

# Week 02 - Application Infrastructure

Week 02 will build on the Week 01 network foundation.

The focus will shift toward infrastructure required to host the application.

Participants should expect to work with concepts such as:

- Compute
- Containers
- Application networking
- Inbound and outbound access
- Storage where required
- Secrets and configuration
- Security rules
- Connectivity between infrastructure components

The exact services may differ between AWS and Azure.

The infrastructure created during this stage should use the network built during Week 01.

---

# Week 03 - Memos and PostgreSQL

Week 03 will focus on getting the actual application workload running.

Participants will deploy Memos and connect it to PostgreSQL.

The database will remain separate from the application workload.

Participants should expect to work with:

- Memos deployment
- Containers
- PostgreSQL
- Application configuration
- Environment variables
- Database connectivity
- Secrets
- Private networking
- Troubleshooting application connectivity

By the end of this stage, Memos should be able to communicate with its PostgreSQL backend.

---

# Week 04 - CI/CD and Infrastructure Automation

Week 04 will introduce more automation around the environment.

The project will use **GitHub Actions** for CI/CD.

Participants will begin working with concepts such as:

- GitHub Actions
- Terraform workflows
- Infrastructure validation
- Automated Terraform plans
- Deployment workflows
- Least-privileged cloud identity
- Secrets and credentials
- Branches
- Pull requests
- Infrastructure review

The goal is to move away from making every infrastructure change manually from a local workstation.

---

# Week 05 - Monitoring and Operations

Week 05 will focus on operating the environment after it has been deployed.

Participants should expect to work with:

- Monitoring
- Logging
- Alerts
- Application health
- Infrastructure health
- Troubleshooting
- Operational visibility
- Cost awareness

AWS participants will work primarily with services such as CloudWatch.

Azure participants will work primarily with services such as Azure Monitor.

The goal is to understand what is happening inside the environment instead of simply assuming that deployed resources are healthy.

---

# Terraform and Portal / Console Options

Participants are allowed to complete the early stages of Project 01 using either:

- Terraform
- AWS Management Console
- Azure Portal

Terraform is strongly encouraged for participants who want Infrastructure as Code experience, but it is not required at the beginning of the project.

As Project 01 progresses, Terraform and automation will become more important.

Participants using the Console or Portal should still follow the same architecture requirements and completion criteria.

The method used to create the infrastructure may be different.

The required outcome should remain the same.

---

# Terraform Expectations

Participants using Terraform should focus on understanding the infrastructure they are creating.

The goal is not simply to copy working Terraform code.

Participants should be able to explain:

- What each resource does
- Why the resource exists
- How resources connect to each other
- Why specific network ranges were selected
- How security rules affect traffic
- How variables are used
- What Terraform outputs provide
- How Terraform state relates to deployed infrastructure

Terraform modules may be introduced as the project grows and the configuration becomes more complex.

Participants are not required to begin Week 01 with a heavily modularized Terraform configuration.

---

# Git and GitHub

Project 01 also introduces Git and GitHub workflows that are commonly used by engineering teams.

Participants should become familiar with:

- Cloning repositories
- Working with branches
- Making commits
- Writing useful commit messages
- Creating pull requests
- Reviewing changes
- Documenting infrastructure
- Working with other engineers

As the project progresses, GitHub will become part of the infrastructure deployment workflow rather than simply a place to store files.

---

# Weekly Instructions

Each platform contains its own weekly instructions.

```text
project-01/
├── README.md
│
├── aws/
│   ├── README.md
│   ├── week-01/
│   │   └── README.md
│   ├── week-02/
│   │   └── README.md
│   ├── week-03/
│   │   └── README.md
│   ├── week-04/
│   │   └── README.md
│   └── week-05/
│       └── README.md
│
└── azure/
    ├── README.md
    ├── week-01/
    │   └── README.md
    ├── week-02/
    │   └── README.md
    ├── week-03/
    │   └── README.md
    ├── week-04/
    │   └── README.md
    └── week-05/
        └── README.md
```

Each weekly README will contain the requirements for that stage of the project.

Participants should complete the current week's requirements before moving forward.

---

# Reference Solutions

CloudClimb project leads maintain separate reference deployments for AWS and Azure.

Reference solutions are built and tested ahead of the community project schedule.

They are **not released at the beginning of each week**.

After a project week has been completed, the reference solution for that week may be published so participants can compare their implementation against a working example before moving into the next stage.

Reference solutions are intended to help participants learn and review their work.

They are not intended to represent the only correct solution.

There may be multiple valid ways to meet the same project requirements.

---

# Portal / Console Reference

Participants who use the AWS Console or Azure Portal may also receive screenshots or examples showing what the completed environment should look like.

These references are meant for validation rather than providing a click-by-click walkthrough of every configuration screen.

The final deployed architecture matters more than following the exact same sequence of clicks.

Portal and Console interfaces may also change over time.

---

# Project Deliverables

Throughout Project 01, participants may be asked to provide items such as:

- Terraform configuration
- Architecture diagrams
- Screenshots
- Resource inventories
- GitHub commits
- Pull requests
- Troubleshooting notes
- Configuration documentation
- Architecture decisions
- Cost observations

The exact deliverables will be defined inside each weekly assignment.

---

# Architecture Documentation

Participants should document their environment as the project grows.

Documentation may include:

- Network diagrams
- CIDR ranges
- Resource names
- Security rules
- Application flow
- Database connectivity
- Identity relationships
- Monitoring configuration
- Architecture decisions

You should be able to explain how traffic moves through your environment and why resources were configured the way they were.

---

# Cost Awareness

Participants are responsible for resources deployed inside their own AWS or Azure accounts.

CloudClimb does not require participants to deploy expensive infrastructure simply to complete the project.

Each weekly assignment will attempt to keep cost in mind and avoid unnecessary services where possible.

Participants should:

- Review pricing before deploying resources
- Use free or low-cost options where practical
- Remove resources that are no longer required
- Avoid leaving unnecessary resources running
- Understand which services generate ongoing charges

Cloud cost management is part of cloud engineering.

---

# Troubleshooting

Not every deployment will work on the first attempt.

That is expected.

Examples may include:

- Terraform errors
- Permission problems
- Network connectivity failures
- Security rule issues
- Application deployment failures
- Database connectivity problems
- CI/CD failures
- Monitoring problems

Troubleshooting is part of the project.

Documenting what failed and how it was fixed can be just as valuable as completing the deployment successfully.

---

# Project Goals

By the end of Project 01, participants should have experience with:

- Designing cloud infrastructure from requirements
- Building segmented cloud networks
- Planning IP addressing and subnets
- Deploying an application workload
- Working with containers
- Connecting applications to backend services
- Working with managed PostgreSQL
- Applying network security controls
- Managing identity and permissions
- Using Infrastructure as Code
- Working with Git branches
- Creating pull requests
- Reviewing infrastructure changes
- Building basic CI/CD workflows
- Monitoring cloud resources
- Troubleshooting failures
- Documenting architecture decisions
- Considering cloud cost
- Explaining why infrastructure was designed a certain way

The goal is to understand the infrastructure supporting the application and be able to explain the technical decisions behind it.

---

# Community Expectations

CloudClimb is designed around collaboration.

Participants are encouraged to:

- Ask questions
- Help troubleshoot
- Share what they learned
- Compare approaches
- Explain technical decisions
- Review each other's work
- Participate in project discussions

Avoid simply posting completed solutions for active project weeks.

Help other participants understand the problem instead of immediately giving them the answer.

---

# Final Outcome

By the end of Project 01, participants should have taken an environment from:

```text
Nothing
```

to something resembling:

```text
Cloud Network
      |
      v
Application Infrastructure
      |
      v
Memos
      |
      v
PostgreSQL
      |
      v
Security + Identity
      |
      v
CI/CD
      |
      v
Monitoring + Operations
```

The final environment should represent more than a collection of deployed resources.

It should represent a small cloud platform that participants have designed, built, secured, automated, monitored, and troubleshot over the course of the project.

That is the purpose of Project 01.

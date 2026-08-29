# Project 01 - CloudClimb Memos Deployment

Project 01 is CloudClimb's first full hands-on cloud engineering project.

The goal is to build and improve one cloud environment over multiple weeks instead of completing disconnected labs.

Throughout the project, participants will deploy and operate **Memos**, an open-source self-hosted note-taking application, while gaining experience with networking, application hosting, security, monitoring, troubleshooting, Infrastructure as Code, GitHub workflows, and cloud architecture.

AWS and Azure participants will follow the same overall business scenario while using services appropriate to their chosen cloud platform.

---

## Project Scenario

A company wants to deploy a lightweight internal web application in the cloud.

The application selected for this project is **Memos**, an open-source self-hosted note-taking platform.

The cloud engineering team is responsible for designing the environment from the ground up and improving it over time.

This includes:

- Cloud networking
- Application hosting
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

The goal is to continue improving the same environment until it becomes a complete cloud-hosted application platform.

---

## About Memos

**Memos** is a lightweight, open-source, self-hosted note-taking application.

It gives Project 01 a real workload to build infrastructure around without requiring participants to develop an application themselves.

Throughout the project, Memos will allow participants to work with concepts such as:

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

Participants are not expected to modify the Memos source code.

The focus of Project 01 is the cloud infrastructure required to deploy, secure, operate, and support the application.

---

## Project Goals

By the end of Project 01, participants should have experience with:

- Designing cloud infrastructure from requirements
- Building segmented cloud networks
- Planning IP addressing and subnets
- Deploying an application workload
- Working with containers
- Connecting applications to backend services
- Applying network security controls
- Managing identity and permissions
- Using Infrastructure as Code
- Working with Git branches
- Creating pull requests
- Reviewing infrastructure changes
- Monitoring cloud resources
- Troubleshooting failures
- Documenting architecture decisions
- Considering cloud cost
- Explaining why infrastructure was designed a certain way

The goal is not simply to make Memos run.

Participants should understand the infrastructure supporting the application and be able to explain their technical decisions.

---

## Supported Platforms

Project 01 currently supports:

- AWS
- Azure

Both tracks will follow the same overall business requirements.

The exact services and architecture may differ between platforms.

For example:

| Requirement | AWS | Azure |
| --- | --- | --- |
| Primary network | VPC | Virtual Network |
| Network security | Security Groups | Network Security Groups |
| Identity and access | IAM | Azure RBAC / Entra ID |
| Monitoring | CloudWatch | Azure Monitor |
| Infrastructure as Code | Terraform | Terraform |

The AWS and Azure environments do not need to be identical.

They should solve the same underlying engineering problem using the services that make sense for each platform.

---

## Repository Structure

Project 01 is organized by cloud platform.

```text
project-01/
├── README.md
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
        └── README.md* Project checkpoints
* AWS and Azure service mappings
* Infrastructure as Code expectations
* Completion criteria

Once those decisions are finalized, this README will be updated with the official Project 01 requirements and instructions.

```
```

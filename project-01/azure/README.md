# Project 01 - Azure Track

This folder contains the Azure implementation of CloudClimb Project 01.

Project 01 uses **Memos**, an open-source self-hosted note-taking application, as the workload participants will deploy and operate throughout the project.

The Azure track follows the same overall business scenario as the AWS track, but the infrastructure will be designed using Azure-native services and architecture.

---

## What You’ll Be Building

Throughout Project 01, Azure participants will build the cloud environment required to support Memos from the ground up.

The environment will grow each week and may include:

- Resource Groups
- Virtual Networks
- Subnets
- Network Security Groups
- Azure RBAC and Entra ID
- Application hosting
- Containers
- Databases
- Monitoring and logging
- Terraform
- GitHub workflows
- CI/CD
- Troubleshooting
- Documentation

The goal is not just to get the application running.

You should understand how the Azure environment works, why the resources were selected, and how the different components work together.

---

## Project Progression

Each week builds on the work completed during the previous week.

### Week 1 - Network Foundation

Build the Azure network foundation that will eventually support Memos.

Topics include:

- Resource Groups
- Virtual Networks
- CIDR planning
- Subnets
- Network Security Groups
- Routing
- Naming conventions
- Resource tags
- Architecture documentation

[View Week 1](week-01/README.md)

---

### Week 2 - Application Deployment

Begin deploying Memos into the Azure environment created during Week 1.

Topics may include:

- Docker
- Containers
- Application hosting
- Environment variables
- Application networking
- Connectivity testing
- Basic troubleshooting

The exact Azure hosting service will be finalized before Week 2 is released.

---

### Week 3 - Security and Access

Improve the security of the Azure environment.

Topics may include:

- Azure RBAC
- Entra ID
- Least privilege
- Secrets management
- Network restrictions
- Private connectivity
- Application-to-database communication

---

### Week 4 - Monitoring and Troubleshooting

Add visibility into the environment and begin working through operational issues.

Topics may include:

- Azure Monitor
- Log Analytics
- Metrics
- Logs
- Alerts
- Application health
- Network troubleshooting
- Permission failures
- Incident-style scenarios

---

### Week 5 - Infrastructure as Code and Automation

Bring the project together using Infrastructure as Code and automation.

Topics may include:

- Terraform
- Variables and outputs
- Reusable configuration
- Git branches
- Pull Requests
- Code reviews
- CI/CD
- Infrastructure validation
- Deployment automation
- Final documentation

---

## Weekly Assignments

Each week's Azure assignment will be located inside its own folder.

```text
azure/
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

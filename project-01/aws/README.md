# Project 01 - AWS Track

This folder contains the AWS implementation of CloudClimb Project 01.

Project 01 uses **Memos**, an open-source self-hosted note-taking application, as the workload participants will build around throughout the project.

The AWS track follows the same overall business scenario as the Azure track, but uses AWS-native services and architecture.

---

## Project Goal

The goal is not simply to deploy Memos.

Participants should understand the AWS infrastructure supporting the application and be able to explain why each major resource exists.

Throughout Project 01, AWS participants will gain experience with areas such as:

- Amazon VPC networking
- Subnets and routing
- Security Groups
- IAM
- Application hosting
- Containers
- Databases
- CloudWatch
- Troubleshooting
- Terraform
- Git and GitHub workflows
- CI/CD
- Documentation
- Cloud cost awareness

---

## Project Progression

Each week builds on the infrastructure created during the previous week.

### Week 1 - Network Foundation

Design and deploy the AWS networking foundation that will eventually support Memos.

Topics include:

- VPC
- Subnets
- CIDR planning
- Route Tables
- Security Groups
- Resource naming
- Tags
- Architecture documentation

[View Week 1](week-01/README.md)

### Week 2 - Application Deployment

Deploy Memos into the AWS environment created during Week 1.

Expected concepts may include:

- Docker
- Containers
- Application hosting
- Environment variables
- Application networking
- Connectivity testing

### Week 3 - Security and Access

Improve the security of the environment.

Expected concepts may include:

- IAM
- Least privilege
- Secrets management
- Network restrictions
- Application-to-database communication
- Private access

### Week 4 - Monitoring and Troubleshooting

Introduce observability and operational troubleshooting.

Expected concepts may include:

- Amazon CloudWatch
- Logs
- Metrics
- Alerts
- Application health
- Network troubleshooting
- Incident-style scenarios

### Week 5 - Infrastructure as Code and Automation

Bring the project together with Infrastructure as Code and automation.

Expected concepts may include:

- Terraform
- Git branches
- Pull Requests
- Code reviews
- CI/CD
- Infrastructure validation
- Deployment automation
- Final documentation

---

## Weekly Assignments

Detailed AWS assignments will be located inside each weekly folder.

```text
aws/
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

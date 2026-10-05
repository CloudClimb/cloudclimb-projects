# Project 01 - Azure Week 04
## Automate Terraform with GitHub Actions
## CI/CD

GitHub Actions is used to validate the Terraform configuration.

Welcome to Week 04 of Project 01.

At this point, you have already built the core application environment.

During previous weeks, you created:

- Azure networking
- Application, Data, and Management subnets
- Network Security Groups
- Linux compute
- SSH access
- Docker
- Memos
- PostgreSQL infrastructure
- Application-to-database connectivity

Until now, most infrastructure changes have been performed manually from your local computer using commands such as:

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

This week, you will begin automating that workflow using GitHub Actions.

The goal is to move from:

```text
Developer Laptop
      |
      v
Terraform
      |
      v
Azure
```

to:

```text
Developer
   |
   v
GitHub
   |
   v
GitHub Actions
   |
   v
Terraform
   |
   v
Azure
```

---

# Week 04 Goal

By the end of Week 04, you should have a GitHub Actions workflow that can:

- Detect Terraform changes
- Check Terraform formatting
- Initialize Terraform
- Validate Terraform configuration
- Generate a Terraform plan
- Authenticate securely to Azure
- Run infrastructure checks automatically
- Understand the difference between CI and CD
- Understand why automated `terraform apply` requires additional safeguards

You will also begin thinking about infrastructure changes as a controlled deployment process rather than simply running commands manually.

---

# What You Will Cover

Week 04 focuses on:

- GitHub Actions
- CI/CD concepts
- Terraform automation
- YAML workflows
- Pull requests
- Automated validation
- Terraform plans
- Azure authentication
- OpenID Connect
- Federated identity
- Least privilege
- GitHub repository permissions
- Workflow permissions
- Infrastructure change reviews
- Protected deployment workflows
- Automation troubleshooting

---

# Time Expectation

Week 04 is designed to take approximately:

**3-4 hours**

Your time may vary depending on:

- GitHub Actions experience
- Azure identity experience
- Terraform repository structure
- OIDC configuration
- Troubleshooting workflow permissions
- Existing GitHub configuration

The goal is not to create a perfect enterprise pipeline.

The goal is to understand the foundation of Infrastructure as Code automation.

---

# Scenario

Your organization has reached a point where infrastructure changes are becoming more frequent.

Engineers currently run Terraform manually from their own computers.

This introduces several problems:

```text
Different Terraform versions

Different local environments

Changes may not be reviewed

Formatting may be inconsistent

Terraform plans may not be visible to the team

Cloud credentials may exist on developer machines

Changes depend heavily on individual engineers
```

The organization wants to begin standardizing Terraform changes using GitHub Actions.

The first goal is to automatically validate infrastructure changes before they are deployed.

---

# CI vs CD

Before building the workflow, understand the difference.

## Continuous Integration

CI focuses on validating changes.

For Terraform, this may include:

```text
terraform fmt -check
terraform init
terraform validate
terraform plan
```

A developer submits a change.

GitHub Actions automatically checks whether the Terraform configuration is valid.

---

## Continuous Deployment

CD goes one step further.

After changes are reviewed and approved, the pipeline may execute:

```bash
terraform apply
```

This modifies real infrastructure.

Because `terraform apply` can create, change, or destroy cloud resources, production environments usually include stronger controls before automated deployment is allowed.

---

# Week 04 Scope

This week will focus primarily on:

```text
Pull Request
      |
      v
Terraform Validation
      |
      v
Terraform Plan
      |
      v
Human Review
```

You may optionally explore controlled deployment afterward.

Do not blindly create a pipeline that automatically applies every commit to Azure.

---

# Task 1 - Review Your Repository

Before creating automation, make sure your Terraform configuration is stored in GitHub.

Your repository should contain files similar to:

```text
project-01/
└── azure/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── README.md
    └── troubleshooting.md
```

Your exact structure may differ.

Do not upload:

```text
terraform.tfstate
terraform.tfstate.backup
.terraform/
Private SSH keys
Passwords
Azure credentials
Sensitive terraform.tfvars
.env files containing secrets
```

---

# Task 2 - Review Your .gitignore

Make sure your repository contains a `.gitignore`.

At minimum, consider excluding:

```text
.terraform/
*.tfstate
*.tfstate.*
terraform.tfvars
*.auto.tfvars
*.pem
.env
```

Do not blindly copy this list if your environment intentionally tracks certain files.

The goal is to prevent sensitive or local-only files from being committed.

---

# Task 3 - Understand GitHub Actions

GitHub Actions allows workflows to run automatically when events occur in your repository.

Examples include:

```text
Push
Pull Request
Manual Trigger
Release
Scheduled Event
```

Workflow files live inside:

```text
.github/workflows/
```

Example:

```text
.github/
└── workflows/
    └── terraform.yml
```

Workflow files use YAML.

---

# Task 4 - Create the Workflow Directory

Inside your repository, create:

```text
.github/workflows/
```

Then create:

```text
terraform.yml
```

Your project may now resemble:

```text
project-01/
├── azure/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
└── .github/
    └── workflows/
        └── terraform.yml
```

Your exact folder structure may differ.

---

# Task 5 - Create a Basic Terraform Validation Workflow

Start simple.

Your first workflow should run when a pull request changes Terraform files.

Example:

```yaml
name: Terraform Validation

on:
  pull_request:
    paths:
      - "project-01/azure/**"

jobs:
  terraform:
    runs-on: ubuntu-latest

    defaults:
      run:
        working-directory: project-01/azure

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v4

      - name: Terraform Format Check
        run: terraform fmt -check

      - name: Terraform Init
        run: terraform init

      - name: Terraform Validate
        run: terraform validate
```

Do not worry about Azure authentication yet.

The first goal is to understand how the workflow runs Terraform commands.

---

# Task 6 - Push the Workflow

Commit the workflow to GitHub.

Example:

```bash
git add .
```

```bash
git commit -m "Add Terraform validation workflow"
```

```bash
git push
```

Then create or update a pull request.

Open:

```text
GitHub
→ Repository
→ Actions
```

Watch the workflow run.

---

# Task 7 - Understand the Workflow

Be able to explain each step.

## Checkout

```yaml
uses: actions/checkout@v4
```

This downloads your repository onto the GitHub Actions runner.

---

## Setup Terraform

```yaml
uses: hashicorp/setup-terraform@v4
```

This installs Terraform on the temporary runner.

---

## Format Check

```bash
terraform fmt -check
```

This confirms that Terraform files follow standard formatting.

---

## Init

```bash
terraform init
```

This initializes Terraform and downloads required providers.

---

## Validate

```bash
terraform validate
```

This checks whether the Terraform configuration is syntactically and structurally valid.

---

# Task 8 - Intentionally Break Formatting

Create a small formatting issue in one Terraform file.

Do not break the infrastructure itself.

Commit the change and observe the workflow.

The expected result should be:

```text
Terraform Format Check
        |
        X
Workflow fails
```

Then fix it locally:

```bash
terraform fmt
```

Push the corrected version.

The workflow should pass.

This demonstrates one benefit of CI:

```text
Problems can be caught before deployment.
```

---

# Task 9 - Add Terraform Plan

The next step is to generate a Terraform plan.

Add:

```yaml
- name: Terraform Plan
  run: terraform plan -input=false
```

However, Terraform now needs access to Azure.

Your GitHub Actions runner does not automatically have your local Azure CLI login.

You must configure secure authentication.

---

# Task 10 - Understand Azure Authentication

Do not copy your personal Azure password into GitHub.

Do not upload Azure CLI credential files.

Do not create long-lived cloud credentials unless required.

For this project, use:

```text
GitHub Actions
      |
      v
OpenID Connect
      |
      v
Microsoft Entra ID
      |
      v
Azure
```

OpenID Connect allows GitHub to request temporary Azure credentials for an approved workflow.

This removes the need to store a permanent client secret in GitHub.

---

# Why OIDC?

Traditional authentication may look like:

```text
GitHub
   |
   | Stored Client Secret
   v
Azure
```

That secret may remain valid for months or years.

OIDC instead works more like:

```text
GitHub Workflow
      |
      | Temporary Identity Token
      v
Microsoft Entra ID
      |
      | Verify trusted repository
      v
Temporary Azure Access
```

This reduces reliance on long-lived credentials.

---

# Task 11 - Create an Azure Identity for GitHub Actions

Create an identity that GitHub Actions can use to access Azure.

One common approach is:

```text
Microsoft Entra Application
        |
        v
Service Principal
        |
        v
Federated Identity Credential
```

The federated identity should trust your GitHub repository.

You will need information such as:

```text
Azure Tenant ID
Azure Subscription ID
Azure Client ID
GitHub Organization
GitHub Repository
GitHub Branch or Environment
```

---

# Task 12 - Configure Federated Identity

Configure Azure to trust GitHub's OIDC provider.

The trust relationship should be specific.

Avoid creating an identity that any random GitHub repository can use.

Conceptually:

```text
Azure trusts:

CloudClimb Organization
        +
Specific Repository
        +
Specific Branch / Environment
```

Not:

```text
Any GitHub repository
```

---

# Task 13 - Assign Azure Permissions

The GitHub Actions identity needs permission to interact with Azure.

Use the least privilege that makes sense for the lab.

For a simple learning environment, you may assign permissions at the Resource Group scope rather than the entire subscription.

Conceptually:

```text
Subscription
   |
   v
Resource Group
   |
   +-- GitHub Actions Identity
          |
          +-- Required Role
```

Avoid granting unnecessary subscription-wide permissions.

---

# Task 14 - Add GitHub Repository Variables

Your workflow will need Azure identifiers.

Common values include:

```text
AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID
```

These values identify the Azure identity, tenant, and subscription.

They are not equivalent to your Azure password.

Depending on your repository strategy, these may be stored as:

```text
Repository Variables
```

or:

```text
Repository Secrets
```

Do not store database passwords or other application secrets unnecessarily.

---

# Task 15 - Add OIDC Workflow Permissions

GitHub needs permission to request an OIDC token.

Add:

```yaml
permissions:
  id-token: write
  contents: read
```

Conceptually:

```text
id-token: write
```

allows the workflow to request an identity token.

```text
contents: read
```

allows the workflow to read the repository.

---

# Task 16 - Authenticate to Azure

Add the Azure Login action before Terraform Plan.

Example:

```yaml
- name: Azure Login
  uses: azure/login@v2
  with:
    client-id: ${{ secrets.AZURE_CLIENT_ID }}
    tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

Your repository may use GitHub variables instead depending on how you configure it.

The important concept is:

```text
GitHub
   |
   v
OIDC
   |
   v
Azure Login
   |
   v
Terraform
```

---

# Task 17 - Build the Full Validation Workflow

Your workflow may now resemble:

```yaml
name: Terraform Validation

on:
  pull_request:
    paths:
      - "project-01/azure/**"

permissions:
  id-token: write
  contents: read

jobs:
  terraform:
    runs-on: ubuntu-latest

    defaults:
      run:
        working-directory: project-01/azure

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v4

      - name: Terraform Format
        run: terraform fmt -check

      - name: Terraform Init
        run: terraform init

      - name: Terraform Validate
        run: terraform validate

      - name: Azure Login
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Terraform Plan
        run: terraform plan -input=false
```

Do not blindly copy this workflow.

Adjust:

```text
Working directory
Repository paths
Branch strategy
Azure identity configuration
```

to match your project.

---

# Task 18 - Create a Test Infrastructure Change

Make a harmless Terraform change.

Examples:

```text
Add a tag

Modify a description

Add an output
```

Do not make a destructive change.

Create a branch:

```bash
git checkout -b test/terraform-pipeline
```

Make your change.

Commit it:

```bash
git add .
git commit -m "Test Terraform CI workflow"
git push
```

Then create a pull request.

---

# Task 19 - Review the Automated Plan

Open the GitHub Actions workflow run.

Review:

```text
Terraform Format
Terraform Init
Terraform Validate
Azure Login
Terraform Plan
```

The plan should show the same type of information you would normally see locally.

For example:

```text
Plan: 0 to add, 1 to change, 0 to destroy
```

The difference is that the plan is now generated by automation.

---

# Why This Matters

Previously:

```text
Engineer
   |
   v
Runs terraform plan locally
   |
   v
Only engineer sees it
```

Now:

```text
Pull Request
     |
     v
GitHub Actions
     |
     v
Terraform Plan
     |
     v
Team Review
```

This creates better visibility around infrastructure changes.

---

# Task 20 - Understand Why Auto-Apply Is Dangerous

It is technically possible to create:

```yaml
- name: Terraform Apply
  run: terraform apply -auto-approve
```

Do not automatically add this to every pull request workflow.

Imagine someone changes:

```text
VM size

Subnet CIDR

Database configuration

Security rules

Resource names
```

and GitHub immediately runs:

```bash
terraform apply -auto-approve
```

The infrastructure could change before anyone reviews the plan.

---

# Better Deployment Flow

A more controlled workflow looks like:

```text
Developer Branch
      |
      v
Pull Request
      |
      v
Terraform Format
      |
      v
Terraform Validate
      |
      v
Terraform Plan
      |
      v
Human Review
      |
      v
Merge
      |
      v
Controlled Apply
```

This separates validation from deployment.

---

# Task 21 - Optional Apply Workflow

If you want to explore CD, create a separate workflow.

Example:

```text
terraform-plan.yml
```

and:

```text
terraform-apply.yml
```

The apply workflow could run:

```text
After merge to main
```

or:

```text
Manual workflow_dispatch
```

For this project, a manual trigger is a good learning option.

Example:

```yaml
on:
  workflow_dispatch:
```

This means a user must manually start the deployment.

---

# Optional Controlled Apply Example

A basic structure may resemble:

```yaml
name: Terraform Apply

on:
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  terraform:
    runs-on: ubuntu-latest

    defaults:
      run:
        working-directory: project-01/azure

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v4

      - name: Azure Login
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan -input=false

      - name: Terraform Apply
        run: terraform apply -auto-approve
```

This is still a learning example.

Production environments usually include additional controls.

---

# Production Considerations

Real environments may use:

```text
Protected branches

Required pull request reviews

GitHub Environments

Environment approvals

Separate dev / test / prod

Remote Terraform state

State locking

Least privilege identities

Separate identities per environment

Policy checks

Security scanning

Cost checks

Artifact retention

Change management
```

You do not need to implement all of these this week.

Understand why they exist.

---

# Task 22 - Review Terraform State

Automation introduces an important question:

```text
Where does Terraform state live?
```

If your state only exists on your laptop:

```text
terraform.tfstate
```

a GitHub Actions runner will not automatically have access to it.

This becomes a problem because each runner is temporary.

For a real shared workflow, Terraform state should be stored remotely.

---

# Remote State Concept

Instead of:

```text
Laptop
   |
   v
terraform.tfstate
```

you eventually want:

```text
Developer
     |
     |
GitHub Actions
     |
     v
Remote Terraform State
     |
     v
Azure
```

Azure-based Terraform projects commonly use Azure Storage for remote state.

---

# Important

If your project is still using local state, do not blindly migrate state during this exercise.

Understand the concept first.

State migration should be done carefully because Terraform state tracks your existing resources.

A bad state migration can cause Terraform to believe resources do not exist.

---

# Task 23 - Pipeline Troubleshooting Challenge

Create or encounter one CI/CD issue and troubleshoot it.

Possible examples:

- Incorrect working directory
- `terraform fmt -check` failure
- Terraform validation error
- Missing GitHub variable
- Incorrect Azure Client ID
- Incorrect Tenant ID
- OIDC permissions missing
- Federated identity mismatch
- Azure RBAC permission denied
- Terraform provider authentication failure
- Workflow path not triggering
- YAML syntax error

Only troubleshoot one issue.

Document what happened.

---

# Troubleshooting Process

Think of the pipeline in layers:

```text
GitHub Event
     |
     v
Workflow Trigger
     |
     v
Runner
     |
     v
Checkout
     |
     v
Terraform Setup
     |
     v
Terraform Init
     |
     v
Azure Authentication
     |
     v
Terraform Plan
     |
     v
Azure API
```

Identify which layer failed.

Do not immediately rewrite the entire workflow.

---

# Task 24 - Update troubleshooting.md

Document your Week 04 issue.

Use:

```markdown
# Week 04 Troubleshooting

## Symptom

What failed?

## Workflow Step

Which GitHub Actions step failed?

## What I Checked

What configuration did you inspect?

## Root Cause

What caused the failure?

## Fix

What change resolved it?

## Verification

How did you verify the pipeline worked afterward?

## What I Learned

What did this teach you about CI/CD, Terraform, GitHub Actions, or Azure authentication?
```

---

# Security Considerations

Before completing Week 04, review:

- Are Azure passwords stored in GitHub?
- Are long-lived Azure secrets being used unnecessarily?
- Is OIDC configured?
- Is the federated identity limited to the expected repository?
- Does the GitHub Actions identity have excessive Azure permissions?
- Can pull requests automatically change production?
- Are database credentials exposed?
- Are Terraform state files committed?
- Are private SSH keys committed?
- Are workflow permissions broader than necessary?

Automation should not reduce security.

---

# Files That Should Not Be Committed

Continue avoiding:

```text
terraform.tfstate
terraform.tfstate.backup
.terraform/
Private SSH keys
Database passwords
Azure passwords
Client secrets
Sensitive terraform.tfvars
.env files containing credentials
```

Automation makes source control more important.

If a secret enters Git history, deleting the visible line later may not be enough.

---

# What Not to Build Yet

Week 04 does not require:

```text
Full enterprise DevSecOps

Complex multi-stage pipelines

Kubernetes deployments

AKS

Application Gateway automation

Blue/green deployment

Canary deployment

Terraform Cloud

Complex policy engines

Multi-region deployment

Full production environment promotion
```

Keep the workflow understandable.

---

# Architecture Update

Your infrastructure automation flow now looks like:

```text
Developer
    |
    v
Feature Branch
    |
    v
GitHub Pull Request
    |
    v
GitHub Actions
    |
    +-- Terraform Format
    |
    +-- Terraform Init
    |
    +-- Terraform Validate
    |
    +-- Azure OIDC Login
    |
    +-- Terraform Plan
    |
    v
Human Review
    |
    v
Merge / Controlled Deployment
    |
    v
Azure Infrastructure
```

Your application architecture from previous weeks remains in place:

```text
Azure
 |
 +-- VNet
 |    |
 |    +-- Application Subnet
 |    |      |
 |    |      v
 |    |   Linux VM
 |    |      |
 |    |   Docker
 |    |      |
 |    |   Memos
 |    |
 |    +-- Data Subnet
 |           |
 |           v
 |       PostgreSQL
 |
 +-- Private DNS
```

Week 04 does not replace that architecture.

It automates how changes are delivered to it.

---

# Acceptance Criteria

Week 04 is complete when:

- Terraform code is stored in GitHub
- Sensitive files are excluded from Git
- `.github/workflows/` exists
- Terraform validation workflow exists
- Pull requests trigger the workflow
- Terraform formatting is checked automatically
- Terraform initializes successfully
- Terraform validates successfully
- Azure authentication uses an approved method
- OIDC concepts are understood
- Terraform Plan runs from GitHub Actions
- Infrastructure changes can be reviewed before deployment
- No Azure password is stored in the repository
- No Terraform state is committed
- At least one CI/CD troubleshooting issue is documented
- You can explain CI vs CD
- You can explain why automatic apply requires controls

---

# Questions You Should Be Able to Answer

Before considering Week 04 complete, make sure you can answer:

1. What is GitHub Actions?

2. What causes a workflow to run?

3. Where are GitHub Actions workflow files stored?

4. What does `actions/checkout` do?

5. What does `hashicorp/setup-terraform` do?

6. Why run `terraform fmt -check`?

7. What does `terraform validate` check?

8. Why does Terraform Plan require Azure authentication?

9. Why can't GitHub Actions automatically use your local Azure CLI session?

10. What is OpenID Connect?

11. Why is OIDC preferable to a long-lived client secret?

12. What is a federated identity credential?

13. Why should the GitHub identity use least privilege?

14. What is the difference between CI and CD?

15. Why should `terraform apply` not automatically run on every pull request?

16. Why is a Terraform plan useful during code review?

17. What happens if Terraform state only exists on your laptop?

18. Why does automation eventually require remote state?

19. What is the purpose of branch protection?

20. Why might production deployments require approvals?

21. What would you check if Azure Login fails?

22. What would you check if a workflow does not trigger?

23. What would you check if Terraform works locally but fails in GitHub Actions?

---

# Deliverables

Your Week 04 deliverables should include:

- GitHub Actions Terraform workflow
- Screenshot or evidence of a successful workflow
- Evidence of:
  - Terraform Format
  - Terraform Init
  - Terraform Validate
  - Terraform Plan
- Azure OIDC configuration
- Federated identity configuration
- Azure RBAC assignment
- Example pull request
- Updated architecture diagram
- Updated `troubleshooting.md`
- Short explanation of your CI/CD workflow

Do not include sensitive credentials in screenshots.

---

# Reference Solution

The official CloudClimb Azure Week 04 reference solution will not be released at the beginning of the week.

Participants should attempt the workflow themselves first.

After Week 04 is completed, a reference implementation may be released for comparison.

The reference solution represents one valid implementation.

It is not the only correct workflow design.

---

# Looking Ahead

At this point, you have moved through:

```text
Week 01
Networking
     |
     v
Week 02
Compute
     |
     v
Week 03
Application + Database
     |
     v
Week 04
CI/CD + Infrastructure Automation
```

The next stage will focus on operating the environment after deployment.

That means beginning to answer questions such as:

```text
Is the application healthy?

Is the VM under pressure?

Is the application generating errors?

Is PostgreSQL healthy?

How do we know when something breaks?

Who gets alerted?
```

That leads into:

```text
Week 05
Monitoring
Logging
Alerting
Operations
```

---

# Week 04 Outcome

By the end of this week, you should understand that Terraform is not only a command-line tool.

Terraform can become part of a controlled engineering workflow.

You should understand how:

```text
Git
+
Pull Requests
+
GitHub Actions
+
OIDC
+
Terraform
+
Azure
```

work together.

The main goal of Week 04 is to move from:

```text
"I run Terraform from my laptop"
```

to:

```text
"Infrastructure changes go through an automated and reviewable deployment process."
```

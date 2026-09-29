# Project 01 - AWS Week 04
## Automate Terraform with GitHub Actions

Welcome to Week 04 of Project 01.

At this point, you have already built the core AWS application environment.

During previous weeks, you created:

- AWS networking
- Application, Data, and Management subnets
- Security Groups
- Linux EC2 compute
- Secure administrative access
- Docker
- Memos
- Amazon RDS for PostgreSQL
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
AWS
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
AWS
```

---

# Week 04 Goal

By the end of Week 04, you should have a GitHub Actions workflow that can:

- Detect Terraform changes
- Check Terraform formatting
- Initialize Terraform
- Validate Terraform configuration
- Generate a Terraform plan
- Authenticate securely to AWS
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
- AWS authentication
- OpenID Connect
- IAM roles
- Trust policies
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
- AWS IAM experience
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

Do not blindly create a pipeline that automatically applies every commit to AWS.

---

# Task 1 - Review Your Repository

Before creating automation, make sure your Terraform configuration is stored in GitHub.

Your repository should contain files similar to:

```text
project-01/
└── aws/
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
.pem files
AWS access keys
AWS secret access keys
Database passwords
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
├── aws/
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
      - "project-01/aws/**"

jobs:
  terraform:
    runs-on: ubuntu-latest

    defaults:
      run:
        working-directory: project-01/aws

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

Do not worry about AWS authentication yet.

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

However, Terraform now needs access to AWS.

Your GitHub Actions runner does not automatically have your local AWS CLI session or local credentials.

You must configure secure authentication.

---

# Task 10 - Understand AWS Authentication

Do not copy personal AWS access keys into GitHub unless there is a specific reason.

Do not store long-lived access key pairs in the repository.

For this project, use:

```text
GitHub Actions
      |
      v
OpenID Connect
      |
      v
AWS IAM
      |
      v
Temporary Role Credentials
```

OpenID Connect allows GitHub to request temporary AWS credentials for an approved workflow.

This removes the need to store permanent AWS access keys in GitHub.

---

# Why OIDC?

Traditional authentication may look like:

```text
GitHub
   |
   | AWS Access Key
   | AWS Secret Access Key
   v
AWS
```

Those credentials may remain valid until manually rotated or disabled.

OIDC instead works more like:

```text
GitHub Workflow
      |
      | Temporary Identity Token
      v
AWS IAM
      |
      | Verify trusted repository
      v
Assume IAM Role
      |
      v
Temporary AWS Credentials
```

This reduces reliance on long-lived credentials.

---

# Task 11 - Create an IAM OIDC Provider

AWS must trust GitHub as an OpenID Connect identity provider.

The GitHub Actions OIDC provider is:

```text
https://token.actions.githubusercontent.com
```

Create an IAM OIDC provider for GitHub if one does not already exist in the AWS account.

Conceptually:

```text
GitHub
   |
   v
OIDC Provider
   |
   v
AWS IAM
```

An AWS account generally only needs one GitHub OIDC provider for this issuer.

Do not create unnecessary duplicate providers.

---

# Task 12 - Create an IAM Role for GitHub Actions

Create an IAM role that GitHub Actions can assume.

Example role name:

```text
cloudclimb-github-actions-role
```

The role should trust GitHub's OIDC provider.

Conceptually:

```text
GitHub Repository
      |
      v
GitHub OIDC
      |
      v
IAM Trust Policy
      |
      v
GitHub Actions Role
```

---

# Task 13 - Configure the IAM Trust Policy

The trust policy determines which GitHub workflows can assume the role.

Do not allow every GitHub repository to use the role.

Restrict it to your organization and repository.

A trust relationship may resemble:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::AWS_ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:CloudClimb/cloudclimb-projects:*"
        }
      }
    }
  ]
}
```

Replace:

```text
AWS_ACCOUNT_ID
CloudClimb/cloudclimb-projects
```

with the correct values for your environment.

The exact repository name may differ.

---

# Understanding the Trust Policy

This part:

```text
token.actions.githubusercontent.com:aud
```

helps verify that the token is intended for AWS STS.

This part:

```text
token.actions.githubusercontent.com:sub
```

helps control which GitHub repository or workflow context can assume the role.

The goal is:

```text
Only approved CloudClimb workflows
          |
          v
Can assume this AWS IAM role
```

Not:

```text
Any GitHub repository
```

---

# Task 14 - Assign IAM Permissions

The GitHub Actions role also needs permissions to interact with AWS.

Use least privilege.

For this lab, the role needs enough permission to:

- Read the resources Terraform manages
- Generate a Terraform plan
- Perform required provider API calls

If you later allow Terraform Apply, the role will need permission to create or modify those resources.

Avoid automatically giving:

```text
AdministratorAccess
```

in real environments.

For a learning lab, you may begin broader if necessary, but understand that production IAM should be scoped to required services and resources.

---

# Trust Policy vs Permission Policy

Do not confuse these two.

## Trust Policy

Answers:

```text
Who can become this role?
```

Example:

```text
GitHub Actions from CloudClimb
```

## Permission Policy

Answers:

```text
What can this role do after it is assumed?
```

Example:

```text
Read EC2
Read VPC
Read RDS
Create specific infrastructure
```

Both are required.

---

# Task 15 - Add GitHub Repository Variables

Your GitHub workflow needs to know which IAM role to assume.

Common values include:

```text
AWS_ROLE_ARN
AWS_REGION
```

Example:

```text
AWS_ROLE_ARN
arn:aws:iam::123456789012:role/cloudclimb-github-actions-role
```

and:

```text
AWS_REGION
us-east-1
```

These may be stored as GitHub repository variables or secrets depending on your repository standards.

The role ARN itself is not an AWS password.

---

# Task 16 - Add OIDC Workflow Permissions

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

allows the workflow to request an OIDC token.

```text
contents: read
```

allows the workflow to read the repository.

---

# Task 17 - Authenticate to AWS

Use the AWS credentials action.

Example:

```yaml
- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v5
  with:
    role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
    aws-region: ${{ secrets.AWS_REGION }}
```

Your repository may use GitHub variables instead.

For example:

```yaml
role-to-assume: ${{ vars.AWS_ROLE_ARN }}
aws-region: ${{ vars.AWS_REGION }}
```

The important flow is:

```text
GitHub Actions
      |
      v
OIDC Token
      |
      v
AWS STS
      |
      v
Assume IAM Role
      |
      v
Temporary AWS Credentials
      |
      v
Terraform
```

---

# Task 18 - Verify AWS Authentication

Before Terraform Plan, add a simple authentication check.

Example:

```yaml
- name: Verify AWS Identity
  run: aws sts get-caller-identity
```

A successful response should identify the assumed role.

This proves GitHub Actions can authenticate to AWS without permanent access keys.

---

# Task 19 - Build the Full Validation Workflow

Your workflow may now resemble:

```yaml
name: Terraform Validation

on:
  pull_request:
    paths:
      - "project-01/aws/**"

permissions:
  id-token: write
  contents: read

jobs:
  terraform:
    runs-on: ubuntu-latest

    defaults:
      run:
        working-directory: project-01/aws

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

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v5
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Verify AWS Identity
        run: aws sts get-caller-identity

      - name: Terraform Plan
        run: terraform plan -input=false
```

Do not blindly copy this workflow.

Adjust:

```text
Working directory
Repository path
AWS Region
Role ARN
Branch strategy
```

to match your project.

---

# Task 20 - Create a Test Infrastructure Change

Make a harmless Terraform change.

Examples include:

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

Commit:

```bash
git add .
git commit -m "Test Terraform CI workflow"
git push
```

Then create a pull request.

---

# Task 21 - Review the Automated Plan

Open the GitHub Actions workflow run.

Review:

```text
Terraform Format
Terraform Init
Terraform Validate
AWS Authentication
Terraform Plan
```

The plan should show the same type of information you normally see locally.

Example:

```text
Plan: 0 to add, 1 to change, 0 to destroy
```

The difference is that the plan is generated automatically inside GitHub Actions.

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

# Task 22 - Understand Temporary AWS Credentials

When GitHub assumes the IAM role through OIDC, AWS returns temporary credentials.

These credentials are short-lived.

Conceptually:

```text
GitHub OIDC Token
      |
      v
AWS STS
      |
      v
Temporary Credentials
```

This is different from storing:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

as long-lived repository secrets.

You should be able to explain why temporary credentials reduce credential-management risk.

---

# Task 23 - Understand Why Auto-Apply Is Dangerous

It is technically possible to add:

```yaml
- name: Terraform Apply
  run: terraform apply -auto-approve
```

Do not automatically add this to every pull request workflow.

Imagine someone modifies:

```text
VPC CIDR

Subnet configuration

Security Group rules

EC2 instance type

RDS settings

Route Tables

Resource names
```

and GitHub immediately executes:

```bash
terraform apply -auto-approve
```

Real infrastructure could change before anyone reviews the plan.

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
AWS Authentication
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

# Task 24 - Optional Apply Workflow

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
        working-directory: project-01/aws

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v4

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v5
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan -input=false

      - name: Terraform Apply
        run: terraform apply -auto-approve
```

This is still a learning example.

Production environments usually include additional safeguards.

---

# Production Considerations

Real AWS environments may use:

```text
Protected branches

Required pull request reviews

GitHub Environments

Deployment approvals

Separate dev / test / prod AWS accounts

Separate IAM roles per environment

Remote Terraform state

State locking

Least privilege IAM

AWS Organizations

Service Control Policies

Security scanning

Cost checks

Artifact retention

Change management
```

You do not need to implement all of these this week.

Understand why they exist.

---

# Task 25 - Review Terraform State

Automation introduces an important question:

```text
Where does Terraform state live?
```

If your state only exists on your laptop:

```text
terraform.tfstate
```

a GitHub Actions runner will not automatically have access to it.

GitHub-hosted runners are temporary.

When one workflow finishes, that runner disappears.

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
AWS
```

AWS Terraform projects commonly use Amazon S3 for remote state.

A shared state architecture may look like:

```text
GitHub Actions
      |
      v
Amazon S3
      |
      v
Terraform State
```

State locking should also be considered for shared environments.

---

# Important

If your Project 01 environment currently uses local state, do not blindly move the state file.

Terraform state tracks your existing infrastructure.

An incorrect migration could cause Terraform to believe existing resources are unmanaged or missing.

Understand the remote-state concept first.

State migration should be intentional and verified.

---

# Task 26 - Understand AWS Account Separation

Many production AWS environments do not place every environment into one account.

A larger organization may use:

```text
AWS Organization
      |
      +-- Development Account
      |
      +-- Test Account
      |
      +-- Production Account
```

GitHub Actions may assume a different IAM role depending on the environment.

Example:

```text
Pull Request
   |
   v
Dev Role

Approved Production Deployment
   |
   v
Production Role
```

You do not need multiple AWS accounts for this lab.

The purpose is to understand why environment separation matters.

---

# Task 27 - Pipeline Troubleshooting Challenge

Create or encounter one CI/CD issue and troubleshoot it.

Possible examples include:

- Incorrect working directory
- `terraform fmt -check` failure
- Terraform validation error
- Missing AWS Region
- Incorrect Role ARN
- OIDC permission missing
- IAM trust policy mismatch
- Repository name mismatch in the `sub` condition
- `sts:AssumeRoleWithWebIdentity` failure
- Insufficient IAM permissions
- Terraform provider authentication failure
- Workflow path not triggering
- YAML syntax error
- Terraform works locally but not in GitHub Actions

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
GitHub OIDC Token
     |
     v
AWS STS
     |
     v
IAM Role
     |
     v
Terraform Plan
     |
     v
AWS APIs
```

Identify which layer failed.

Do not immediately rewrite the entire workflow.

---

# Task 28 - Update troubleshooting.md

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

What did this teach you about CI/CD, Terraform, GitHub Actions, OIDC, STS, or AWS IAM?
```

---

# Security Considerations

Before completing Week 04, review:

- Are AWS access keys stored in GitHub?
- Are long-lived AWS credentials being used unnecessarily?
- Is GitHub OIDC configured?
- Is the IAM trust policy restricted to the expected repository?
- Does the GitHub Actions role have excessive permissions?
- Can pull requests automatically change production?
- Are database credentials exposed?
- Are Terraform state files committed?
- Are `.pem` files committed?
- Are workflow permissions broader than necessary?
- Is the IAM role limited to required resources where practical?

Automation should not reduce security.

---

# Files That Should Not Be Committed

Continue avoiding:

```text
terraform.tfstate
terraform.tfstate.backup
.terraform/
Private SSH keys
.pem files
Database passwords
AWS access keys
AWS secret access keys
Sensitive terraform.tfvars
.env files containing credentials
```

Automation makes source control more important.

If credentials enter Git history, removing the visible line later may not be enough.

---

# What Not to Build Yet

Week 04 does not require:

```text
Full enterprise DevSecOps

Complex multi-stage pipelines

ECS deployment pipelines

EKS

Kubernetes

Blue/green deployments

Canary deployments

Terraform Cloud

Complex policy engines

Multi-region deployment

Full production environment promotion

Advanced AWS Organizations architecture
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
    +-- GitHub OIDC
    |
    +-- AWS STS
    |
    +-- Assume IAM Role
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
AWS Infrastructure
```

Your application architecture from previous weeks remains in place:

```text
AWS
 |
 +-- VPC
      |
      +-- Application Subnets
      |      |
      |      v
      |   EC2 Instance
      |      |
      |   Docker
      |      |
      |   Memos
      |
      +-- Data Subnets
             |
             v
        Amazon RDS PostgreSQL
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
- GitHub OIDC is configured for AWS
- An IAM role exists for GitHub Actions
- The IAM trust policy restricts access appropriately
- GitHub Actions successfully assumes the IAM role
- `aws sts get-caller-identity` succeeds
- Terraform Plan runs from GitHub Actions
- Infrastructure changes can be reviewed before deployment
- No permanent AWS access keys are required in GitHub
- No Terraform state is committed
- At least one CI/CD troubleshooting issue is documented
- You can explain CI vs CD
- You can explain IAM trust policies vs permission policies
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

8. Why does Terraform Plan require AWS authentication?

9. Why can't GitHub Actions automatically use your local AWS CLI credentials?

10. What is OpenID Connect?

11. Why is OIDC preferable to permanent AWS access keys?

12. What is AWS STS?

13. What does `AssumeRoleWithWebIdentity` do?

14. What is an IAM role?

15. What is the difference between an IAM trust policy and permission policy?

16. Why should the trust policy restrict the GitHub repository?

17. Why should the GitHub Actions IAM role use least privilege?

18. What does `aws sts get-caller-identity` verify?

19. What is the difference between CI and CD?

20. Why should `terraform apply` not automatically run on every pull request?

21. Why is Terraform Plan useful during code review?

22. What happens if Terraform state only exists on your laptop?

23. Why does automation eventually require remote state?

24. Why might Amazon S3 be used for Terraform state?

25. Why might production environments use separate AWS accounts?

26. What would you check if GitHub cannot assume the AWS IAM role?

27. What would you check if a workflow does not trigger?

28. What would you check if Terraform works locally but fails in GitHub Actions?

---

# Deliverables

Your Week 04 deliverables should include:

- GitHub Actions Terraform workflow
- Screenshot or evidence of a successful workflow
- Evidence of:
  - Terraform Format
  - Terraform Init
  - Terraform Validate
  - AWS OIDC Authentication
  - `aws sts get-caller-identity`
  - Terraform Plan
- IAM OIDC provider configuration
- IAM Role for GitHub Actions
- IAM trust policy
- IAM permissions used by the workflow
- Example pull request
- Updated architecture diagram
- Updated `troubleshooting.md`
- Short explanation of your CI/CD workflow

Do not include sensitive credentials in screenshots.

---

# Reference Solution

The official CloudClimb AWS Week 04 reference solution will not be released at the beginning of the week.

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

Is EC2 under pressure?

Is Memos generating errors?

Is RDS healthy?

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
AWS STS
+
IAM
+
Terraform
+
AWS
```

work together.

The main goal of Week 04 is to move from:

```text
"I run Terraform from my laptop"
```

to:

```text
"Infrastructure changes go through an automated, authenticated, and reviewable deployment process."
```

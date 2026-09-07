# Contributing to CloudClimb

CloudClimb uses GitHub collaboration workflows to help organize project development and simulate how changes are handled on a real engineering team.

This guide is for contributors who are helping build or improve CloudClimb project materials.

If you are simply completing a CloudClimb project, you do not need to submit your solution to this repository or open a Pull Request.

Project participants should follow the instructions inside the weekly project README and build the infrastructure in their own AWS account or Azure subscription.

## Contribution Workflow

If you are contributing changes to the CloudClimb repository:

1. Pull the latest version of the repository.
2. Create a new branch for your work.
3. Make your changes on that branch.
4. Commit your changes with a clear commit message.
5. Push your branch to GitHub.
6. Open a Pull Request into `main`.
7. Have your changes reviewed.
8. Make any requested updates.
9. Merge the Pull Request after approval.

## Do Not Work Directly on Main

Contributors should not make project changes directly to the `main` branch.

The `main` branch should represent the current approved version of the CloudClimb project.

Changes should be developed on separate branches and reviewed through Pull Requests before being merged.

## Branch Naming

Use branch names that clearly describe what you are working on.

Examples:

```text
feature/aws-networking
feature/azure-networking
feature/terraform-vnet
feature/aws-monitoring
docs/project-01
docs/week-01
fix/azure-nsg
fix/aws-routing
```

## What Belongs in This Repository

The public CloudClimb repository contains:

- Project instructions
- Weekly modules
- AWS project requirements
- Azure project requirements
- Documentation
- Architecture guidance
- Troubleshooting exercises
- Released reference materials

Future solutions should not be added to the public repository before the corresponding project week has ended.

CloudClimb project leads may work ahead using the private project solutions repository.

## Active Project Weeks

Do not publish complete solutions for an active project week.

Participants should have time to build, research, troubleshoot, and complete the requirements before seeing a reference implementation.

Reference solutions will be released after the corresponding week closes.

## Pull Requests

When opening a Pull Request:

- Clearly explain what you changed
- Keep the change focused
- Explain why the change is needed
- Test infrastructure changes when possible
- Update documentation when necessary
- Do not include credentials or sensitive information

## Sensitive Files

Never commit cloud credentials, passwords, private keys, Terraform state, or other sensitive information.

Files such as these should remain local:

```text
terraform.tfvars
terraform.tfstate
terraform.tfstate.backup
.terraform/
*.tfplan
.env
private keys
cloud credentials
```

Example configuration files can be committed when needed:

```text
terraform.tfvars.example
```

## Project Participation

You do not need to contribute to this repository to participate in CloudClimb projects.

Participants can:

- Build locally
- Create their own GitHub repository
- Fork the CloudClimb repository if they prefer

The CloudClimb repository serves as the source of truth for official project instructions.

## Goal

The contribution workflow gives members who help develop CloudClimb experience with:

```text
Branch
  ↓
Commit
  ↓
Push
  ↓
Pull Request
  ↓
Review
  ↓
Merge
```

This helps keep CloudClimb organized while also giving contributors experience with a Git workflow commonly used on engineering teams.Fix subnet configuration
Add Terraform variables
```

## Pull Requests

Pull Requests should explain:

* What was changed
* Why the change was made
* What part of the project it relates to
* Any issues or considerations reviewers should know about

Pull Requests should be reviewed before being merged into `main`.

## Communication

Use the CloudClimb Discord for:

* Project discussions
* Questions
* Troubleshooting
* Architecture decisions
* Team coordination

Use GitHub for:

* Project files
* Infrastructure as Code
* Documentation
* Issues and tasks
* Branches
* Pull Requests
* Code reviews

## Cloud Credentials

Never commit passwords, API keys, access keys, secrets, tokens, or other sensitive information to the repository.

Use environment variables, secret management tools, or local configuration files that are excluded from Git when credentials are required.

```
```

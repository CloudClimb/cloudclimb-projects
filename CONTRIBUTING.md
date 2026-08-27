````md
# Contributing to CloudClimb

CloudClimb is designed to give contributors experience working through cloud projects as part of a team.

To keep the repository organized and simulate a real engineering workflow, contributors should follow the process below.

## Contribution Workflow

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

## Branch Naming

Use branch names that clearly explain what you are working on.

Examples:

```text
feature/aws-networking
feature/azure-networking
feature/terraform-vnet
feature/aws-monitoring
docs/project-01
fix/azure-nsg
````

## Commit Messages

Use short, clear commit messages.

Examples:

```text
Add Azure VNet configuration
Create AWS VPC resources
Update Project 01 documentation
Fix subnet configuration
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

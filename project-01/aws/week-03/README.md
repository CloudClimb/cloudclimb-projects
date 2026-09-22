# Project 01 - AWS Week 03
## Deploy Memos and Connect It to Amazon RDS for PostgreSQL

Welcome to Week 03 of Project 01.

In Week 01, you built the AWS network foundation.

In Week 02, you added application compute by deploying a Linux EC2 instance into the Application tier and configuring secure administrative access.

This week, you will finally deploy the actual application workload.

The goal of Week 03 is to:

- Install Docker on the existing EC2 instance
- Deploy Memos as a container
- Deploy Amazon RDS for PostgreSQL
- Place the database across the existing Data Subnets
- Keep the database private
- Configure application-to-database security
- Connect Memos to PostgreSQL
- Allow users to reach the Memos application
- Troubleshoot application or database connectivity
- Continue documenting the environment

You are still building on the same infrastructure.

Do not create a completely separate environment.

---

# Scenario

The company now has:

- A segmented AWS VPC
- Application Subnets
- Data Subnets
- Management Subnets
- A Linux EC2 application host
- Security Groups
- Secure administrative access

The next requirement is to deploy the Memos application and provide it with a managed PostgreSQL backend.

The application should run on the Linux EC2 instance created during Week 02.

The database should not run directly on the EC2 instance.

Instead, Amazon RDS for PostgreSQL will provide a separate managed database tier.

---

# Week 03 Goal

By the end of Week 03, your environment should progress from:

```text
Week 02

Internet
   |
   v
Application Tier
   |
   v
EC2 Instance
```

to:

```text
Week 03

Internet
   |
   v
Application Security Group
   |
   v
Application Subnet
   |
   v
EC2 Instance
   |
   v
Docker
   |
   v
Memos
   |
   | PostgreSQL TCP 5432
   v
RDS Security Group
   |
   v
Data Subnets
   |
   v
Amazon RDS for PostgreSQL
```

The application and database should exist as separate infrastructure components.

---

# What You Will Cover

Week 03 focuses on:

- Docker
- Linux package management
- Containers
- Application ports
- Amazon RDS
- PostgreSQL
- DB Subnet Groups
- Security Group references
- Private database networking
- RDS endpoints
- Environment variables
- Database connection strings
- Terraform resource relationships
- Troubleshooting
- Secrets awareness
- Cost awareness

The goal is not simply to make Memos appear in a browser.

You should understand how the application reaches the database and how traffic moves through the AWS environment.

---

# Time Expectation

Week 03 is designed to take approximately:

**3-4 hours**

Your time may vary depending on:

- Your AWS experience
- Whether you use Terraform or the AWS Console
- Docker familiarity
- RDS provisioning time
- Troubleshooting
- Documentation

Take your time.

The application-to-database connection is one of the most important parts of this project.

---

# Prerequisites

Before starting Week 03, you should already have:

- Week 01 VPC
- Application Subnets
- Data Subnets
- Management Subnets
- Route Tables
- Internet Gateway
- Security Groups
- Linux EC2 instance from Week 02
- Working administrative access
- Outbound internet connectivity from the EC2 instance

Your Week 01 design should already include Data Subnets in multiple Availability Zones.

These will now become useful for Amazon RDS.

---

# Task 1 - Connect to the Linux EC2 Instance

Start the EC2 instance if it is currently stopped.

You can do this through:

- AWS Console
- AWS CLI
- Terraform, if instance lifecycle is being managed that way

Retrieve the public IP or DNS name of the instance if needed.

Connect to the server using the method configured during Week 02.

Example:

```bash
ssh -i YOUR_PRIVATE_KEY.pem ec2-user@EC2_PUBLIC_IP
```

Your username may differ depending on the Linux distribution you deployed.

For example:

```text
Amazon Linux = ec2-user
Ubuntu       = ubuntu
```

Once connected, verify the server:

```bash
hostname
```

```bash
ip addr
```

Confirm outbound connectivity:

```bash
curl https://example.com
```

---

# Task 2 - Install Docker

Memos will run inside a Docker container.

Before installing Docker, check whether it is already available:

```bash
docker --version
```

If Docker is not installed, install Docker using the appropriate method for your Linux distribution.

After installation, verify:

```bash
docker --version
```

Check the Docker service:

```bash
sudo systemctl status docker
```

Enable Docker to start automatically if needed:

```bash
sudo systemctl enable docker
```

Start Docker if needed:

```bash
sudo systemctl start docker
```

You may optionally configure your Linux user to run Docker commands without `sudo`.

---

# Why Docker?

Containers give us a repeatable way to run Memos without manually installing every application dependency directly onto the EC2 instance.

Conceptually:

```text
EC2 Instance
     |
     v
Docker Engine
     |
     v
Memos Container
```

EC2 provides the compute.

Docker provides the container runtime.

Memos runs as the application workload.

---

# Task 3 - Test Memos Locally

Before introducing PostgreSQL, confirm that the Memos container itself works.

Run Memos:

```bash
docker run -d \
  --name memos \
  --restart unless-stopped \
  -p 5230:5230 \
  -v ~/.memos:/var/opt/memos \
  neosmemo/memos:stable
```

Check the running container:

```bash
docker ps
```

Review the logs:

```bash
docker logs memos
```

Memos should be listening on:

```text
TCP 5230
```

At this stage, Memos will use SQLite.

That is temporary.

The goal is only to confirm that Docker and Memos work before adding the database layer.

---

# Task 4 - Allow Memos Application Traffic

Your EC2 Security Group should already allow your administrative access from Week 02.

Memos now needs an inbound application rule.

Allow:

```text
TCP 5230
```

For this learning environment, you may allow TCP 5230 from your own public IP address.

Example:

```text
Type:        Custom TCP
Port:        5230
Source:      YOUR_PUBLIC_IP/32
Description: Memos Application Access
```

Do not open every port.

Only expose the traffic required for the application.

Conceptually:

```text
Your Computer
     |
     | TCP 5230
     v
Application Security Group
     |
     v
EC2 Instance
     |
     v
Memos
```

---

# Task 5 - Test Memos in the Browser

Retrieve the public IP of your EC2 instance.

Then open:

```text
http://EC2_PUBLIC_IP:5230
```

You should see the Memos application.

Create the initial administrator account if prompted.

At this point, you have proven:

- EC2 is working
- Docker is working
- Memos is running
- Port 5230 is mapped correctly
- The Security Group allows application traffic
- The EC2 instance can serve the application

Do not stop here.

SQLite is temporary for this project.

Next, you will build the managed PostgreSQL backend.

---

# Task 6 - Review the Data Subnets

Amazon RDS will use the Data Subnets created during Week 01.

Your architecture should include Data Subnets in at least two Availability Zones.

Example:

```text
VPC
 |
 +-- Availability Zone A
 |      |
 |      +-- Application Subnet A
 |      |
 |      +-- Data Subnet A
 |
 +-- Availability Zone B
        |
        +-- Application Subnet B
        |
        +-- Data Subnet B
```

The Data Subnets should remain private.

They should not require direct inbound access from the internet.

---

# Task 7 - Create an RDS DB Subnet Group

Amazon RDS uses a DB Subnet Group to determine which subnets can host the database.

Create a DB Subnet Group containing your Data Subnets.

Conceptually:

```text
DB Subnet Group
      |
      +-- Data Subnet A
      |
      +-- Data Subnet B
```

If you are using Terraform, your configuration may look similar to:

```hcl
resource "aws_db_subnet_group" "memos" {
  name = "cloudclimb-project01-db-subnet-group"

  subnet_ids = [
    aws_subnet.data_a.id,
    aws_subnet.data_b.id
  ]

  tags = {
    Name = "cloudclimb-project01-db-subnet-group"
  }
}
```

Use your own Terraform resource names.

Do not copy reference names blindly if your configuration is different.

---

# Why a DB Subnet Group?

The DB Subnet Group tells RDS which private network locations are available for the database.

Instead of placing the database directly into one subnet, RDS is given a group of eligible subnets across Availability Zones.

Conceptually:

```text
Amazon RDS
    |
    v
DB Subnet Group
    |
    +-- Data Subnet A
    |
    +-- Data Subnet B
```

This is an AWS-specific difference from the Azure implementation.

---

# Task 8 - Create an RDS Security Group

Create a dedicated Security Group for the PostgreSQL database.

The database should allow:

```text
TCP 5432
```

But do not allow it from:

```text
0.0.0.0/0
```

Instead, allow PostgreSQL traffic from the Security Group attached to your application EC2 instance.

Conceptually:

```text
Application Security Group
          |
          | TCP 5432
          v
Database Security Group
          |
          v
Amazon RDS PostgreSQL
```

This means:

```text
Resources using the application Security Group
                  |
                  v
       Can reach PostgreSQL
```

rather than:

```text
Entire Internet
      |
      X
      |
PostgreSQL
```

---

# Terraform Example - Database Security Group

Example:

```hcl
resource "aws_security_group" "database" {
  name        = "cloudclimb-project01-database-sg"
  description = "Allow PostgreSQL traffic from application tier"
  vpc_id      = aws_vpc.project.id

  tags = {
    Name = "cloudclimb-project01-database-sg"
  }
}
```

Then create the PostgreSQL inbound rule.

Example:

```hcl
resource "aws_vpc_security_group_ingress_rule" "postgres_from_app" {
  security_group_id            = aws_security_group.database.id
  referenced_security_group_id = aws_security_group.app.id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
}
```

Your exact resource names may differ.

The important concept is:

```text
Source = Application Security Group
Port   = TCP 5432
Target = Database Security Group
```

---

# Task 9 - Deploy Amazon RDS for PostgreSQL

Deploy an Amazon RDS DB instance using PostgreSQL.

Use a small development-appropriate configuration.

Your database should:

- Use PostgreSQL
- Use the existing VPC
- Use the DB Subnet Group
- Use the dedicated database Security Group
- Not be publicly accessible
- Use development-sized compute
- Use reasonable storage for a lab
- Create a database for Memos
- Use strong credentials

Avoid unnecessary production features for this lab.

You do not need:

- Multi-AZ production deployment
- Read replicas
- Large instance classes
- Large storage allocations
- Production backup retention
- Enterprise-scale performance settings

Keep the environment small and understandable.

---

# Suggested Database Naming

Example RDS identifier:

```text
cloudclimb-project01-postgres
```

Example database name:

```text
memos
```

Example administrator username:

```text
pgadminuser
```

Do not use these exact values if they conflict with your existing naming standards.

Maintain consistency with Weeks 01 and 02.

---

# Terraform Example - RDS PostgreSQL

A basic Terraform resource may resemble:

```hcl
resource "aws_db_instance" "memos" {
  identifier = "cloudclimb-project01-postgres"

  engine         = "postgres"
  engine_version = "YOUR_SUPPORTED_POSTGRES_VERSION"

  instance_class        = "YOUR_DEV_INSTANCE_CLASS"
  allocated_storage     = 20
  storage_type          = "gp3"

  db_name  = "memos"
  username = var.postgres_admin_username
  password = var.postgres_admin_password

  db_subnet_group_name = aws_db_subnet_group.memos.name

  vpc_security_group_ids = [
    aws_security_group.database.id
  ]

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "cloudclimb-project01-postgres"
  }
}
```

Choose an engine version and instance class currently supported in your AWS Region and account.

Review your Terraform plan before deploying.

---

# Task 10 - Protect Database Credentials

Create Terraform variables for sensitive database information.

Example:

```hcl
variable "postgres_admin_username" {
  description = "Administrator username for PostgreSQL"
  type        = string
}

variable "postgres_admin_password" {
  description = "Administrator password for PostgreSQL"
  type        = string
  sensitive   = true
}
```

Do not hardcode the real password directly inside:

```text
main.tf
```

Do not commit real credentials to GitHub.

If you use:

```text
terraform.tfvars
```

make sure sensitive versions of that file are excluded from Git.

---

# Task 11 - Deploy the Database

Before applying:

```bash
terraform fmt
```

```bash
terraform validate
```

```bash
terraform plan
```

Review the plan carefully.

You should expect Terraform to create resources related to:

```text
DB Subnet Group
Database Security Group
PostgreSQL Security Group Rule
RDS PostgreSQL Instance
```

You should not see Terraform unexpectedly destroying your Week 01 or Week 02 infrastructure.

If the plan looks correct:

```bash
terraform apply
```

RDS deployment may take several minutes.

---

# Task 12 - Find the RDS Endpoint

Once the RDS instance is available, retrieve its endpoint.

You can find it through the AWS Console or AWS CLI.

Example:

```bash
aws rds describe-db-instances \
  --db-instance-identifier cloudclimb-project01-postgres \
  --query "DBInstances[0].Endpoint.Address" \
  --output text
```

You should receive a hostname similar to:

```text
cloudclimb-project01-postgres.xxxxxxxxxxxx.us-east-1.rds.amazonaws.com
```

Do not connect using an IP address.

Use the RDS endpoint.

---

# Why Use the RDS Endpoint?

AWS manages the underlying database infrastructure.

Your application should connect using the RDS DNS endpoint.

Conceptually:

```text
Memos
   |
   | RDS Endpoint
   v
AWS DNS
   |
   v
Amazon RDS PostgreSQL
```

Do not hardcode an underlying database IP address.

---

# Task 13 - Test Database Connectivity from EC2

Before configuring Memos, prove that the EC2 instance can reach PostgreSQL.

Install PostgreSQL client tools if necessary.

For Ubuntu:

```bash
sudo apt update
sudo apt install postgresql-client -y
```

For Amazon Linux, use the appropriate package manager for your installed version.

Then test DNS resolution:

```bash
nslookup YOUR_RDS_ENDPOINT
```

You can also test TCP connectivity:

```bash
nc -vz YOUR_RDS_ENDPOINT 5432
```

Then attempt to connect using PostgreSQL:

```bash
psql \
  --host=YOUR_RDS_ENDPOINT \
  --port=5432 \
  --username=YOUR_DATABASE_USER \
  --dbname=memos
```

Enter the database password when prompted.

A successful connection proves:

- EC2 can resolve the RDS endpoint
- Network routing works
- The RDS Security Group allows the application tier
- TCP 5432 is reachable
- PostgreSQL is accepting connections
- Your credentials work

---

# Task 14 - Stop the Temporary SQLite Memos Container

Once PostgreSQL connectivity works, stop the Memos container currently using SQLite.

Example:

```bash
docker stop memos
```

Remove the container:

```bash
docker rm memos
```

This removes the container but does not remove the EC2 instance.

The goal is to recreate Memos using PostgreSQL.

---

# Task 15 - Configure Memos for PostgreSQL

Memos supports PostgreSQL using environment variables.

The important settings are:

```text
MEMOS_DRIVER
MEMOS_DSN
```

Set:

```text
MEMOS_DRIVER=postgres
```

The database connection string should contain:

```text
Database username
Database password
RDS endpoint
Port 5432
Database name
```

A PostgreSQL connection string follows a format similar to:

```text
postgres://USERNAME:PASSWORD@RDS_ENDPOINT:5432/memos
```

Your exact configuration may also require PostgreSQL SSL settings.

Do not commit your real connection string to GitHub.

---

# Task 16 - Run Memos with PostgreSQL

Start the Memos container again using PostgreSQL.

Your configuration should include:

```text
MEMOS_DRIVER=postgres
MEMOS_DSN=YOUR_POSTGRES_CONNECTION_STRING
```

Conceptually:

```text
Docker
   |
   v
Memos
   |
   | MEMOS_DRIVER=postgres
   |
   | MEMOS_DSN
   v
RDS PostgreSQL
```

Memos should still expose:

```text
5230:5230
```

Do not place your real database password in a public repository.

---

# Task 17 - Verify the Memos Container

Check:

```bash
docker ps
```

Review the logs:

```bash
docker logs memos
```

Look for database connection errors.

If the application starts successfully, open:

```text
http://EC2_PUBLIC_IP:5230
```

Confirm Memos loads.

Create a test memo or perform another simple application action.

The application should now be using Amazon RDS for PostgreSQL instead of SQLite.

---

# Task 18 - Understand the Traffic Flow

You should be able to explain the complete path.

User traffic:

```text
Your Computer
      |
      | TCP 5230
      v
Internet
      |
      v
Internet Gateway
      |
      v
Application Security Group
      |
      v
EC2 Instance
      |
      v
Docker
      |
      v
Memos
```

Database traffic:

```text
Memos
   |
   | TCP 5432
   v
Application Security Group
   |
   v
Database Security Group
   |
   v
RDS Endpoint
   |
   v
Amazon RDS PostgreSQL
```

The RDS database itself should not require public internet access.

---

# Security Group Relationship

One of the most important concepts this week is that AWS Security Groups can reference other Security Groups.

Instead of:

```text
Allow PostgreSQL from 0.0.0.0/0
```

you should have something similar to:

```text
Database Security Group

Inbound:
TCP 5432

Source:
Application Security Group
```

This creates a logical trust relationship between the application tier and database tier.

---

# Task 19 - Troubleshooting Challenge

Part of Week 03 is troubleshooting the application-to-database path.

Create or encounter one small issue and diagnose it.

Possible examples include:

- Incorrect RDS endpoint
- Incorrect database username
- Incorrect database password
- Incorrect database name
- Database Security Group missing TCP 5432
- Incorrect Security Group used as the source
- RDS placed in the wrong subnet group
- RDS accidentally configured as publicly accessible
- Memos container not running
- Port 5230 missing from the EC2 Security Group
- Incorrect Docker environment variable
- Incorrect MEMOS_DSN
- PostgreSQL connection failure

Only troubleshoot one issue.

Do not intentionally destroy the database or EC2 instance.

---

# Troubleshooting Process

If the browser cannot reach Memos:

```text
Browser
   |
   v
Internet Gateway
   |
   v
Security Group
   |
   v
EC2
   |
   v
Docker
   |
   v
Memos
```

If Memos cannot reach PostgreSQL:

```text
Memos
   |
   v
RDS Endpoint
   |
   v
VPC Networking
   |
   v
Database Security Group
   |
   v
RDS PostgreSQL
```

Check one layer at a time.

Do not immediately rebuild the environment.

---

# Useful Troubleshooting Commands

Check running containers:

```bash
docker ps
```

Check all containers:

```bash
docker ps -a
```

Check logs:

```bash
docker logs memos
```

Check DNS:

```bash
nslookup YOUR_RDS_ENDPOINT
```

Check PostgreSQL port connectivity:

```bash
nc -vz YOUR_RDS_ENDPOINT 5432
```

Check PostgreSQL directly:

```bash
psql \
  --host=YOUR_RDS_ENDPOINT \
  --port=5432 \
  --username=YOUR_DATABASE_USER \
  --dbname=memos
```

If TCP 5432 fails, investigate:

```text
Application Security Group
Database Security Group
DB Subnet Group
RDS status
RDS endpoint
Network ACLs
Routing
```

---

# Troubleshooting Documentation

Create or update:

```text
troubleshooting.md
```

Document:

```markdown
# Week 03 Troubleshooting

## Symptom

What was not working?

## What I Checked

Which services or network layers did you investigate?

## Root Cause

What caused the problem?

## Fix

What change resolved it?

## Verification

How did you prove the issue was fixed?

## What I Learned

What did this teach you about Docker, EC2, Security Groups, RDS, or PostgreSQL?
```

Keep the explanation clear and concise.

---

# Terraform Option

Terraform is strongly encouraged for participants already using Infrastructure as Code.

Week 03 may require Terraform resources related to:

```text
RDS DB Subnet Group
RDS PostgreSQL DB Instance
Database Security Group
Security Group Rules
Application Security Group Rule for Memos
Sensitive Variables
```

Do not copy Terraform code without understanding what each resource does.

Continue building on the infrastructure from previous weeks.

---

# AWS Console Option

Console users may create the same environment manually.

The required outcome remains the same.

Console users should still understand:

- Why RDS uses Data Subnets
- Why multiple Data Subnets are used
- What a DB Subnet Group does
- Why RDS should remain private
- How Security Groups control application-to-database traffic
- Why the application Security Group is used as the database rule source
- What the RDS endpoint represents
- Which ports are being used
- Which resources are public
- Which resources are private

---

# Network Ports

You should understand the important ports used this week.

```text
22    = SSH
5230  = Memos
5432  = PostgreSQL
```

These ports serve different purposes.

Do not simply expose all of them to the internet.

Your architecture should resemble:

```text
Internet
   |
   | 22 - restricted administrative access
   |
   | 5230 - application access
   v
EC2 Instance

EC2 Instance
   |
   | 5432 - private application-to-database traffic
   v
Amazon RDS PostgreSQL
```

PostgreSQL should not be directly exposed to the internet.

---

# Public vs Private Resources

At this point in Project 01:

## Public-facing

The EC2 application host may have:

```text
Public IPv4 Address
```

because it currently provides:

```text
Administrative access
Memos application access
```

## Private

Amazon RDS should remain:

```text
Publicly Accessible = False
```

Database traffic should remain inside the VPC.

Conceptually:

```text
Internet
    |
    v
EC2
    |
    | Private VPC Traffic
    v
RDS
```

---

# Security Considerations

Before finishing Week 03, review:

- Is administrative access still restricted?
- Is PostgreSQL publicly accessible?
- Does the RDS Security Group allow `0.0.0.0/0`?
- Is TCP 5432 restricted to the application tier?
- Is the database password committed anywhere?
- Is the database connection string stored in GitHub?
- Is only the required application port exposed?
- Does Memos communicate with RDS privately?
- Are unnecessary Security Group rules present?
- Are you using the RDS endpoint instead of a hardcoded IP?

Do not commit secrets.

---

# Secrets

For this stage, keep secret handling simple.

Do not store real database credentials in:

```text
main.tf
variables.tf
README.md
GitHub
docker-compose.yml
public terraform.tfvars files
.env files committed to Git
```

Sensitive local files should be excluded through:

```text
.gitignore
```

More advanced AWS secret management may be introduced later.

---

# Cost Awareness

Week 03 introduces another resource that can generate ongoing charges:

```text
Amazon RDS
```

Review pricing before deployment.

Use development-sized resources.

Avoid:

- Large DB instance classes
- Multi-AZ unless required
- Read replicas
- Excessive storage
- Production-scale backups
- Additional database instances

Continue stopping the EC2 instance when it is not required.

Remember:

Stopping EC2 does not stop RDS billing.

RDS continues running separately.

Delete unused lab resources when the project no longer requires them.

---

# What Not to Deploy Yet

Week 03 does not require:

- Application Load Balancer
- Auto Scaling Group
- ECS
- EKS
- Kubernetes
- Route 53 custom domain
- CloudFront
- Full CI/CD
- GitHub Actions deployment pipeline
- CloudWatch alerting architecture
- AWS Secrets Manager integration
- Multi-AZ production RDS
- Read replicas
- Multiple application servers

Those concepts may be introduced later or are outside the current Project 01 scope.

Keep the architecture understandable.

---

# Task 20 - Update Your Architecture Diagram

Update your Project 01 architecture diagram.

Your diagram should now include:

- VPC
- Availability Zones
- Application Subnets
- Data Subnets
- Management Subnets
- Internet Gateway
- Route Tables
- EC2 Instance
- Application Security Group
- Database Security Group
- Docker
- Memos
- DB Subnet Group
- Amazon RDS for PostgreSQL
- Application traffic
- Database traffic

Example:

```text
                         Internet
                            |
                            v
                     Internet Gateway
                            |
                            v
                 Application Security Group
                            |
                            v
                 Application Subnet - AZ A
                            |
                            v
                      EC2 Instance
                            |
                            v
                         Docker
                            |
                            v
                          Memos
                            |
                            | TCP 5432
                            v
                  Database Security Group
                            |
                            v
                     DB Subnet Group
                      /           \
                     /             \
                    v               v
            Data Subnet A       Data Subnet B
                AZ A                AZ B
                     \             /
                      \           /
                       v         v
                  Amazon RDS PostgreSQL
```

---

# Acceptance Criteria

Week 03 is complete when:

- Week 01 networking is still being used
- Week 02 EC2 instance is still being used
- Docker is installed
- Docker service is running
- Memos container runs successfully
- TCP 5230 is configured appropriately
- Memos can be reached from a browser
- Data Subnets are reused
- DB Subnet Group is created
- Database Security Group is created
- PostgreSQL TCP 5432 is restricted appropriately
- Amazon RDS for PostgreSQL is deployed
- RDS is not publicly accessible
- RDS endpoint resolves from EC2
- EC2 can reach PostgreSQL on TCP 5432
- A Memos database exists
- Memos is configured to use PostgreSQL
- Memos successfully starts with the PostgreSQL backend
- Database credentials are not committed publicly
- At least one troubleshooting scenario is documented
- Architecture diagram is updated
- You can explain the complete application flow

---

# Questions You Should Be Able to Answer

Before considering Week 03 complete, make sure you can answer:

1. Why are we using Docker?

2. What is the difference between EC2 and the Memos container?

3. What does `5230:5230` mean in Docker?

4. What is the purpose of the Data Subnets?

5. Why does RDS use a DB Subnet Group?

6. Why should the DB Subnet Group contain subnets in multiple Availability Zones?

7. Why is PostgreSQL separate from EC2?

8. What port does PostgreSQL use?

9. Why should RDS not be publicly accessible?

10. What is an RDS endpoint?

11. Why should the application use the RDS endpoint instead of an IP address?

12. What is the difference between the Application Security Group and Database Security Group?

13. Why can the Database Security Group reference the Application Security Group?

14. Why is that better than allowing TCP 5432 from `0.0.0.0/0`?

15. What does `MEMOS_DRIVER=postgres` tell Memos?

16. What is the purpose of `MEMOS_DSN`?

17. Why should database credentials not be committed to GitHub?

18. How does a browser request reach the Memos container?

19. How does Memos reach RDS?

20. What would you check if Memos loads but database operations fail?

21. What would you check if the browser cannot reach Memos?

22. Which resources from Weeks 01 and 02 are being reused?

---

# Deliverables

Your Week 03 deliverables should include:

- Updated architecture diagram
- Evidence Docker is running
- Evidence the Memos container is running
- Evidence Memos is reachable
- Evidence the RDS instance was deployed
- Evidence RDS is not publicly accessible
- Evidence the DB Subnet Group contains the expected Data Subnets
- Evidence the Database Security Group restricts TCP 5432
- Evidence EC2 can reach the RDS endpoint
- Evidence Memos is configured to use PostgreSQL
- Terraform configuration if Terraform was used
- Updated `troubleshooting.md`
- Short explanation of the application-to-database traffic flow

Do not include secrets in screenshots or committed files.

---

# Files That Should Not Be Committed

Do not commit:

```text
terraform.tfstate
terraform.tfstate.backup
.terraform/
Private SSH keys
.pem files
Database passwords
AWS access keys
AWS secret access keys
Sensitive terraform.tfvars files
.env files containing credentials
```

If a file contains a real database connection string or password, treat it as sensitive.

---

# Reference Solution

The official CloudClimb AWS Week 03 reference solution will not be released at the beginning of the week.

Participants should attempt the project requirements themselves first.

After Week 03 is completed, a reference implementation may be released for comparison.

The reference solution represents one working implementation.

It is not the only valid architecture.

---

# Looking Ahead

At the end of Week 03, Project 01 should now have an actual working application stack:

```text
AWS Network
    |
    v
EC2 Compute
    |
    v
Docker
    |
    v
Memos
    |
    v
Amazon RDS PostgreSQL
```

The next stage of Project 01 will begin focusing more heavily on automation and deployment workflows.

A later architecture may begin to look like:

```text
GitHub
   |
   v
GitHub Actions
   |
   v
Terraform / Deployment
   |
   v
AWS Infrastructure
   |
   v
Memos
```

The environment built during Weeks 01-03 will continue to be used.

---

# Week 03 Outcome

By the end of this week, you should understand more than how to start a Docker container.

You should understand:

- How an application runs on EC2
- How Docker interacts with the EC2 host
- How application ports are exposed
- How Amazon RDS fits into a cloud architecture
- Why databases should remain private
- How DB Subnet Groups work
- Why AWS uses multiple Data Subnets
- How Security Groups can reference other Security Groups
- How EC2 reaches RDS over the VPC
- How DNS endpoints are used for managed databases
- How Memos connects to PostgreSQL
- How to troubleshoot application and database connectivity
- Why credentials must be protected
- How Weeks 01, 02, and 03 form one connected AWS environment

The main goal of Week 03 is to move from **infrastructure that exists** to **infrastructure that actually runs an application**.

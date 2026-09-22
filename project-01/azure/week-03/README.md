# Project 01 - Azure Week 03
## Deploy Memos and Connect It to PostgreSQL

Welcome to Week 03 of Project 01.

In Week 01, you built the Azure network foundation.

In Week 02, you added application compute by deploying a Linux Virtual Machine into the Application Subnet and securing administrative access with SSH.

This week, you will finally deploy the actual application workload.

The goal of Week 03 is to:

- Install Docker on the existing Linux VM
- Deploy Memos as a container
- Deploy Azure Database for PostgreSQL Flexible Server
- Place the database in the existing Data Subnet
- Configure private application-to-database connectivity
- Connect Memos to PostgreSQL
- Allow users to reach the Memos application
- Troubleshoot application or database connectivity
- Continue documenting the environment

You are still building on the same infrastructure.

Do not create a completely separate environment.

---

# Scenario

The company now has:

- A segmented Azure network
- An Application Subnet
- A Data Subnet
- A Management Subnet
- A Linux application host
- Secure SSH access

The next requirement is to deploy the Memos application and provide it with a managed PostgreSQL backend.

The application should run on the Linux VM created during Week 02.

The database should not run inside the application VM.

Instead, Azure Database for PostgreSQL Flexible Server will provide a separate managed database tier.

---

# Week 03 Goal

By the end of Week 03, your environment should progress from:

```text
Week 02

Internet
   |
   v
Application Subnet
   |
   v
Linux VM
```

to:

```text
Week 03

Internet
   |
   v
Application NSG
   |
   v
Application Subnet
   |
   v
Linux VM
   |
   v
Docker
   |
   v
Memos
   |
   | PostgreSQL TCP 5432
   v
Data Subnet
   |
   v
Azure Database for PostgreSQL
```

The application and database should exist as separate infrastructure components.

---

# What You Will Cover

Week 03 focuses on:

- Docker
- Linux package management
- Containers
- Application ports
- Azure Database for PostgreSQL Flexible Server
- Database networking
- Subnet delegation
- Private application-to-database connectivity
- DNS
- Environment variables
- Database connection strings
- Application configuration
- Network Security Groups
- Terraform resource relationships
- Troubleshooting
- Secrets awareness
- Cost awareness

The goal is not simply to make Memos appear in a browser.

You should understand how the application reaches the database and how traffic moves through the environment.

---

# Time Expectation

Week 03 is designed to take approximately:

**3-4 hours**

Your time may vary depending on:

- Your Azure experience
- Whether you use Terraform or the Azure Portal
- Docker familiarity
- PostgreSQL deployment time
- Troubleshooting
- Documentation

Take your time.

The application-to-database connection is one of the most important parts of this project.

---

# Prerequisites

Before starting Week 03, you should already have:

- Week 01 Resource Group
- Week 01 Virtual Network
- Application Subnet
- Data Subnet
- Management Subnet
- Network Security Groups
- Linux VM from Week 02
- Network Interface
- Public IP
- Working SSH access
- SSH key authentication
- Outbound internet connectivity from the VM

Start your VM if it is currently deallocated.

Example:

```bash
az vm start \
  --resource-group YOUR_RESOURCE_GROUP \
  --name YOUR_VM_NAME
```

---

# Task 1 - Connect to the Linux VM

Retrieve the Azure VM Public IP if needed.

Example:

```bash
az network public-ip show \
  --resource-group YOUR_RESOURCE_GROUP \
  --name YOUR_PUBLIC_IP_RESOURCE \
  --query ipAddress \
  --output tsv
```

Connect:

```bash
ssh azureuser@VM_PUBLIC_IP
```

Confirm the VM is available:

```bash
hostname
```

```bash
ip addr
```

```bash
sudo apt update
```

---

# Task 2 - Install Docker

Memos will run inside a Docker container.

Before installing Docker, confirm that it is not already installed:

```bash
docker --version
```

If Docker is not installed, install Docker using an appropriate installation method for your Linux distribution.

After installation, verify:

```bash
docker --version
```

Confirm the Docker service is running:

```bash
sudo systemctl status docker
```

You may also configure your Linux user to run Docker without using `sudo`.

If you modify Docker group membership, you may need to log out and reconnect before the change takes effect.

---

# Why Docker?

Containers give us a repeatable way to run the application without manually installing every application dependency directly onto the VM.

Conceptually:

```text
Linux VM
   |
   v
Docker Engine
   |
   v
Memos Container
```

The Linux VM provides the compute.

Docker provides the container runtime.

Memos runs as the application workload.

---

# Task 3 - Test Memos Locally

Before connecting Memos to PostgreSQL, confirm that the container itself can run.

A simple Memos container can be started with:

```bash
docker run -d \
  --name memos \
  --restart unless-stopped \
  -p 5230:5230 \
  -v ~/.memos:/var/opt/memos \
  neosmemo/memos:stable
```

This starts Memos using its default SQLite configuration.

For this task, SQLite is only being used temporarily to confirm that the application container works.

Check the running container:

```bash
docker ps
```

View logs:

```bash
docker logs memos
```

The application listens on:

```text
TCP 5230
```

---

# Task 4 - Allow Memos Application Traffic

Your Application NSG currently allows SSH access.

Memos now needs an inbound application rule.

Allow TCP port:

```text
5230
```

For this learning environment, you may allow application traffic from the internet so you can test Memos in your browser.

Example traffic flow:

```text
Internet
   |
   | TCP 5230
   v
Application NSG
   |
   v
Linux VM
   |
   v
Memos Container
```

Do not open every port.

Only add the application port that is required.

---

# Task 5 - Test Memos in the Browser

Once the NSG rule is configured, open:

```text
http://VM_PUBLIC_IP:5230
```

You should see the Memos application.

At this point, you have proven:

- Docker is working
- The Memos image can run
- Port 5230 is mapped correctly
- The Azure NSG allows application traffic
- The VM can serve an application

Do not stop here.

SQLite is temporary for this project.

The next step is to create the managed PostgreSQL backend.

---

# Task 6 - Prepare the Data Subnet

Azure Database for PostgreSQL Flexible Server using private VNet integration requires a delegated subnet.

The Data Subnet created during Week 01 will now be used for this purpose.

Delegate the Data Subnet to:

```text
Microsoft.DBforPostgreSQL/flexibleServers
```

Conceptually:

```text
Virtual Network
   |
   +-- Application Subnet
   |      |
   |      v
   |   Linux VM
   |
   +-- Data Subnet
          |
          | Delegated to PostgreSQL
          v
      PostgreSQL
```

The Data Subnet should be reserved for the PostgreSQL Flexible Server when using this networking model.

---

# Terraform Example - Subnet Delegation

If you are using Terraform, your existing Data Subnet may need to be updated.

Example:

```hcl
resource "azurerm_subnet" "data" {
  name                 = var.data_subnet_name
  resource_group_name  = azurerm_resource_group.project.name
  virtual_network_name = azurerm_virtual_network.project.name
  address_prefixes     = [var.data_subnet_prefix]

  delegation {
    name = "postgresql-delegation"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}
```

Review your Terraform plan carefully before applying changes to an existing subnet.

---

# Task 7 - Deploy Azure Database for PostgreSQL

Deploy an Azure Database for PostgreSQL Flexible Server.

Use a small development-appropriate configuration.

Your PostgreSQL server should:

- Use the existing Resource Group
- Use the same Azure region as the VNet
- Use the delegated Data Subnet
- Use private networking
- Use a development-sized compute tier
- Use PostgreSQL
- Have a database created for Memos

Avoid deploying unnecessary high-availability or production-sized resources for this lab.

---

# Database Naming

Example names might include:

```text
cloudclimb-project01-postgres
```

and a database such as:

```text
memos
```

Your exact naming convention may differ.

Maintain consistency with the standards you established in earlier weeks.

---

# Task 8 - Configure Private DNS

When using private VNet integration, the application needs to be able to resolve the PostgreSQL server hostname.

Configure the required Azure Private DNS integration.

The goal is for the Linux VM in the Application Subnet to resolve the PostgreSQL server by hostname.

Conceptually:

```text
Linux VM
   |
   | DNS lookup
   v
Private DNS
   |
   v
PostgreSQL Private Address
```

Do not hardcode the database private IP into your application configuration.

Use the PostgreSQL server hostname.

---

# Task 9 - Test Database Connectivity

Before connecting Memos to PostgreSQL, test the connection from the Linux VM.

You may install PostgreSQL client tools:

```bash
sudo apt update
```

```bash
sudo apt install postgresql-client -y
```

Confirm that the PostgreSQL hostname resolves:

```bash
nslookup YOUR_POSTGRES_HOSTNAME
```

or:

```bash
dig YOUR_POSTGRES_HOSTNAME
```

Then test PostgreSQL connectivity:

```bash
psql \
  --host=YOUR_POSTGRES_HOSTNAME \
  --username=YOUR_DATABASE_USER \
  --dbname=memos
```

You may be prompted for the database password.

A successful connection proves that:

- DNS works
- Routing works
- The VM can reach the database
- PostgreSQL is accepting connections
- The credentials are valid

---

# Task 10 - Stop the Temporary Memos Container

If Memos is currently running with SQLite, stop and remove the temporary container.

Example:

```bash
docker stop memos
```

```bash
docker rm memos
```

The goal is to recreate the Memos container using PostgreSQL instead of SQLite.

---

# Task 11 - Configure Memos for PostgreSQL

Memos supports PostgreSQL through environment variables.

The important settings are:

```text
MEMOS_DRIVER
MEMOS_DSN
```

Set:

```text
MEMOS_DRIVER=postgres
```

The database connection string will contain information such as:

```text
Database username
Database password
PostgreSQL hostname
Port 5432
Database name
```

Do not commit real database credentials to GitHub.

---

# Example Memos PostgreSQL Connection

A PostgreSQL connection string follows a structure similar to:

```text
postgres://USERNAME:PASSWORD@HOSTNAME:5432/memos
```

Your exact connection settings may require SSL options depending on the database configuration.

Do not copy example credentials directly.

Use the values from your own Azure PostgreSQL deployment.

---

# Task 12 - Run Memos with PostgreSQL

Start the Memos container again, this time using PostgreSQL.

Your configuration should include:

```text
MEMOS_DRIVER=postgres
MEMOS_DSN=YOUR_POSTGRES_CONNECTION_STRING
```

The container should still expose:

```text
5230:5230
```

Conceptually:

```text
Memos Container
      |
      | MEMOS_DRIVER=postgres
      |
      | MEMOS_DSN
      v
Azure PostgreSQL
```

Do not place the real database password into a public GitHub repository.

---

# Task 13 - Verify the Application

Check that the container is running:

```bash
docker ps
```

Review the logs:

```bash
docker logs memos
```

Then open:

```text
http://VM_PUBLIC_IP:5230
```

Confirm that Memos loads.

Create a test memo or perform another simple application action.

The application should now be using PostgreSQL rather than SQLite.

---

# Task 14 - Verify Application-to-Database Traffic

You should be able to explain the traffic flow:

```text
User
  |
  | TCP 5230
  v
Azure VM Public IP
  |
  v
Application NSG
  |
  v
Linux VM
  |
  v
Memos Container
  |
  | TCP 5432
  v
Azure PostgreSQL
```

The database itself should not need to be directly exposed to the public internet.

The application talks to the database privately through the VNet.

---

# Task 15 - Troubleshooting Challenge

Part of Week 03 is troubleshooting the application-to-database path.

Create or encounter one small failure and diagnose it.

Possible examples include:

- Incorrect PostgreSQL hostname
- Incorrect database username
- Incorrect database password
- Incorrect database name
- DNS resolution failure
- Data Subnet delegation issue
- PostgreSQL connectivity failure
- Memos container not running
- Port 5230 not allowed through the NSG
- Incorrect Docker environment variable
- Incorrect application connection string

Only troubleshoot one issue.

Do not intentionally destroy the database or VM.

---

# Troubleshooting Process

Separate the problem into layers.

If the browser cannot reach Memos:

```text
Browser
   |
   v
Public IP
   |
   v
NSG
   |
   v
VM
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
DNS
   |
   v
VNet
   |
   v
Data Subnet
   |
   v
PostgreSQL
```

Check one layer at a time.

---

# Useful Troubleshooting Commands

Check containers:

```bash
docker ps
```

Check all containers including stopped containers:

```bash
docker ps -a
```

Check logs:

```bash
docker logs memos
```

Check DNS:

```bash
nslookup YOUR_POSTGRES_HOSTNAME
```

Check port connectivity:

```bash
nc -vz YOUR_POSTGRES_HOSTNAME 5432
```

Check PostgreSQL directly:

```bash
psql \
  --host=YOUR_POSTGRES_HOSTNAME \
  --username=YOUR_DATABASE_USER \
  --dbname=memos
```

Do not immediately rebuild the environment.

Identify which layer is failing first.

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

Which layers or services did you investigate?

## Root Cause

What caused the problem?

## Fix

What change resolved it?

## Verification

How did you prove the issue was fixed?

## What I Learned

What did this teach you about containers, networking, DNS, or databases?
```

Keep the explanation clear and concise.

---

# Terraform Option

Terraform is strongly encouraged for participants already using Infrastructure as Code.

Week 03 may require Terraform resources related to:

```text
PostgreSQL Flexible Server
PostgreSQL Database
Subnet Delegation
Private DNS
NSG Rule for Memos
```

Do not copy Terraform code without understanding what each resource does.

The goal is to continue growing the existing deployment.

---

# Azure Portal Option

Portal users may create the same environment manually.

The required outcome remains the same.

Portal users should still understand:

- Why the Data Subnet is delegated
- Why the database is private
- How the VM resolves the PostgreSQL hostname
- How Memos connects to PostgreSQL
- Which ports are being used
- Which resources are publicly reachable
- Which resources remain private

---

# Network Ports

You should understand the important ports used this week.

```text
22    = SSH
5230  = Memos
5432  = PostgreSQL
```

These ports serve different purposes.

Do not simply open all of them to the internet.

A simplified design should look like:

```text
Internet
   |
   | 22 - restricted admin access
   | 5230 - application access
   v
Linux VM

Linux VM
   |
   | 5432 - private database traffic
   v
PostgreSQL
```

PostgreSQL should not require direct public access for this architecture.

---

# Security Considerations

Before finishing Week 03, review:

- Is SSH still restricted?
- Is PostgreSQL publicly exposed?
- Is the database password committed anywhere?
- Is the database connection string stored in GitHub?
- Is only the required application port exposed?
- Does Memos communicate with PostgreSQL privately?
- Are unnecessary NSG rules present?
- Are you using the correct database hostname rather than a hardcoded IP?

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
public .tfvars files
```

If you need local variables or environment files containing secrets, make sure they are excluded from Git.

Later project stages may introduce more advanced secret-management approaches.

---

# Cost Awareness

Week 03 introduces another resource that can generate ongoing charges:

```text
Azure Database for PostgreSQL Flexible Server
```

Review pricing before deployment.

Use development-sized resources.

Avoid:

- Production-sized compute
- Unnecessary high availability
- Excessive storage
- Additional replicas

Continue deallocating the VM when it is not required.

Be aware that managed database costs may continue even when the application VM is deallocated.

---

# What Not to Deploy Yet

Week 03 does not require:

- Application Gateway
- Azure Load Balancer
- Kubernetes
- AKS
- Full CI/CD
- GitHub Actions deployment pipelines
- Azure Monitor alerting
- Advanced Key Vault integration
- Multiple application servers
- Production high availability
- Custom domains
- HTTPS reverse proxy

Those concepts may be introduced later or are outside the scope of Project 01.

Keep the architecture understandable.

---

# Task 16 - Update Your Architecture Diagram

Update your Project 01 diagram.

Your diagram should now include:

- Resource Group
- Virtual Network
- Application Subnet
- Data Subnet
- Management Subnet
- Application NSG
- Linux VM
- Network Interface
- Public IP
- Docker
- Memos
- PostgreSQL Flexible Server
- Private DNS
- Application traffic
- Database traffic

Example:

```text
Internet
   |
   | TCP 5230
   v
Public IP
   |
   v
Application NSG
   |
   v
Application Subnet
   |
   v
Linux VM
   |
   v
Docker
   |
   v
Memos
   |
   | TCP 5432
   v
Private DNS
   |
   v
Data Subnet
   |
   v
Azure Database for PostgreSQL
```

---

# Acceptance Criteria

Week 03 is complete when:

- Week 01 networking is still being used
- Week 02 Linux VM is still being used
- Docker is installed
- Docker service is running
- Memos container runs successfully
- TCP 5230 is configured appropriately
- Memos can be reached from a browser
- Data Subnet is prepared for PostgreSQL
- PostgreSQL Flexible Server is deployed
- PostgreSQL is privately connected to the VNet
- Private DNS resolution works
- A Memos database exists
- The VM can reach PostgreSQL on TCP 5432
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

2. What is the difference between the VM and the Memos container?

3. What does `5230:5230` mean in Docker?

4. What is the purpose of the Data Subnet?

5. Why does Azure PostgreSQL require subnet delegation when using VNet integration?

6. Why is PostgreSQL separate from the application VM?

7. What port does PostgreSQL use?

8. Why should PostgreSQL not be directly exposed to the internet?

9. What does Private DNS provide?

10. How does the Linux VM find the PostgreSQL server?

11. What does `MEMOS_DRIVER=postgres` tell Memos?

12. What is the purpose of `MEMOS_DSN`?

13. Why should database credentials not be committed to GitHub?

14. How does a browser request reach the Memos container?

15. How does Memos reach PostgreSQL?

16. What would you check if Memos loads but database operations fail?

17. What would you check if the browser cannot reach Memos at all?

18. Which resources from Weeks 01 and 02 are being reused?

---

# Deliverables

Your Week 03 deliverables should include:

- Updated architecture diagram
- Evidence Docker is running
- Evidence the Memos container is running
- Evidence Memos is reachable
- Evidence PostgreSQL was deployed
- Evidence the database uses the expected private networking
- Evidence the VM can reach PostgreSQL
- Evidence Memos is configured to use PostgreSQL
- NSG configuration
- Terraform configuration if Terraform was used
- Updated `troubleshooting.md`
- Short explanation of the application-to-database traffic flow

Do not include secrets in screenshots or files.

---

# Files That Should Not Be Committed

Do not commit:

```text
terraform.tfstate
terraform.tfstate.backup
.terraform/
Private SSH keys
Database passwords
Azure credentials
Sensitive .tfvars files
.env files containing credentials
```

If a file contains a database connection string with a real password, treat it as sensitive.

---

# Reference Solution

The official CloudClimb Azure Week 03 reference solution will not be released at the beginning of the week.

Participants should attempt the project requirements themselves first.

After Week 03 is completed, a reference implementation may be released for comparison.

The reference solution represents one working implementation.

It is not the only valid architecture.

---

# Looking Ahead

At the end of Week 03, Project 01 should now have an actual working application stack:

```text
Azure Network
     |
     v
Linux Compute
     |
     v
Docker
     |
     v
Memos
     |
     v
PostgreSQL
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
Azure Infrastructure
   |
   v
Memos
```

The environment you built during Weeks 01-03 will continue to be used.

---

# Week 03 Outcome

By the end of this week, you should understand more than how to start a Docker container.

You should understand:

- How an application runs on cloud compute
- How containers interact with the host VM
- How application ports are exposed
- How a managed database fits into a cloud architecture
- How private database networking works
- Why subnet delegation exists
- How DNS supports private service connectivity
- How an application uses environment variables
- How Memos connects to PostgreSQL
- How to troubleshoot application and database connectivity
- Why credentials must be protected
- How Weeks 01, 02, and 03 form one connected cloud environment

The main goal of Week 03 is to move from **infrastructure that exists** to **infrastructure that actually runs an application**.

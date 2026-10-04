# Azure Week 03 Reference Solution

This folder contains the reference implementation for **CloudClimb Project 01 - Azure Week 03**.

Week 03 builds on the networking and compute resources from Weeks 01 and 02.

The goal of this week was to deploy the Memos application in Docker, connect it to Azure Database for PostgreSQL, and troubleshoot the application-to-database path.

---

## What This Solution Includes

This reference solution includes:

- Existing Azure VNet
- Application, Data, and Management subnets
- Network Security Groups
- Linux VM
- Static Public IP
- NIC
- SSH key authentication
- Docker
- Memos
- Azure Database for PostgreSQL Flexible Server
- PostgreSQL firewall rule
- Terraform variables
- Terraform outputs
- Troubleshooting documentation

---

## Architecture

The original intended design was:

```text
East US

VNet
 |
 +-- Application Subnet
 |      |
 |      v
 |   Linux VM
 |      |
 |   Docker
 |      |
 |   Memos
 |
 +-- Data Subnet
        |
        v
   Private PostgreSQL
```

The preferred design was to keep the application and PostgreSQL database in the same region and use private networking.

During the lab, the Azure subscription being used did not allow PostgreSQL Flexible Server to be provisioned in East US.

Instead of rebuilding the entire environment in another region, the database portion was adapted.

The final lab design became:

```text
East US
 |
 +-- VNet
      |
      +-- Application Subnet
      |      |
      |      v
      |   Linux VM
      |      |
      |   Docker
      |      |
      |   Memos
      |
      +-- Data Subnet
      |
      +-- Management Subnet

Memos VM
   |
   | TCP 5432
   v

Central US
 |
 v
Azure Database for PostgreSQL Flexible Server
```

PostgreSQL uses a public endpoint for this lab, but access is restricted with a firewall rule so only the application VM can connect.

This is a **lab workaround**, not the preferred production architecture.

---

## Week 03 Flow

The environment was built and tested in this order:

```text
Start existing Linux VM
        |
        v
Install Docker
        |
        v
Run Memos with SQLite
        |
        v
Verify Memos in browser
        |
        v
Deploy PostgreSQL
        |
        v
Test TCP 5432
        |
        v
Test PostgreSQL login
        |
        v
Create memos database
        |
        v
Restart Memos using PostgreSQL
        |
        v
Verify application
```

---

## Why Memos Was Tested With SQLite First

Memos was first started using its default SQLite backend.

This allowed the application layer to be tested before introducing PostgreSQL.

That confirmed:

- Docker was working
- The Memos container could start
- Port 5230 was exposed correctly
- The Application NSG allowed the traffic
- The application could be reached in a browser

This made troubleshooting easier because the application and database layers could be tested separately.

---

## Docker

Docker is installed on the Linux VM and is used to run the Memos container.

```text
Linux VM
   |
   v
Docker
   |
   v
Memos
```

Using Docker keeps the application deployment repeatable and separates the application runtime from the underlying VM.

---

## Application Access

Memos listens on:

```text
TCP 5230
```

The Application NSG allows this traffic only from the configured source IP.

SSH access uses:

```text
TCP 22
```

SSH is also restricted to the configured source IP.

---

## PostgreSQL

The PostgreSQL Flexible Server uses:

```text
PostgreSQL 16
Burstable development SKU
32 GB storage
Central US
```

Public network access is enabled only because the database had to be deployed in another region for this lab.

The PostgreSQL firewall restricts access to the application VM.

---

## Database Connectivity

The application VM connects to PostgreSQL using the PostgreSQL FQDN.

Example:

```text
cloudclimb-project01-postgres-dev01.postgres.database.azure.com
```

The network path is:

```text
Memos
  |
  | TCP 5432
  v
PostgreSQL Firewall
  |
  v
Azure Database for PostgreSQL
```

Before configuring Memos, TCP connectivity was tested:

```bash
nc -vz POSTGRES_FQDN 5432
```

The PostgreSQL client was then used to verify authentication:

```bash
psql \
  --host=POSTGRES_FQDN \
  --username=pgadminuser \
  --dbname=postgres
```

A dedicated database was then created:

```sql
CREATE DATABASE memos;
```

---

## Memos PostgreSQL Configuration

The temporary SQLite-backed container was removed and recreated using PostgreSQL.

Memos uses:

```text
MEMOS_DRIVER=postgres
```

and:

```text
MEMOS_DSN
```

The DSN follows a structure similar to:

```text
postgres://USERNAME:PASSWORD@POSTGRES_FQDN:5432/memos?sslmode=require
```

Do not commit a real DSN containing credentials to GitHub.

---

## Folder Contents

```text
reference-solution/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
├── README.md
├── troubleshooting.md
├── .terraform.lock.hcl
└── .gitignore
```

---

## File Breakdown

### `main.tf`

Contains the Azure infrastructure resources, including:

- Resource Group
- VNet
- Subnets
- NSGs
- Public IP
- NIC
- Linux VM
- PostgreSQL Flexible Server
- PostgreSQL firewall rule

---

### `variables.tf`

Defines reusable Terraform variables for:

- Resource names
- Azure region
- CIDR ranges
- Source IP
- PostgreSQL credentials
- Tags

---

### `outputs.tf`

Displays useful deployment values such as:

- Resource Group name
- VNet information
- Subnet IDs
- VM name
- VM public IP
- VM private IP
- NIC ID
- PostgreSQL server name
- PostgreSQL FQDN

---

### `terraform.tfvars.example`

Provides example values that participants can copy.

Create your local file with:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then replace placeholder values with your own.

Do not commit the real `terraform.tfvars`.

---

### `troubleshooting.md`

Documents the issues encountered during the reference deployment, including:

- PostgreSQL regional provisioning restriction
- Azure Policy tag requirements
- PostgreSQL server naming conflict
- Terraform availability zone drift
- SSH source IP changes
- PostgreSQL firewall source IP issue
- Docker container naming conflict

---

### `.terraform.lock.hcl`

Terraform's dependency lock file.

This file should normally be generated by:

```bash
terraform init
```

It records the provider versions selected for the configuration.

---

### `.gitignore`

Prevents local and sensitive files from being committed.

Examples include:

```text
terraform.tfvars
terraform.tfstate
.terraform/
Private keys
.env files
```

---

## Running the Reference Solution

Create your local variable file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Update the values for your environment.

Then run:

```bash
terraform init
```

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

If everything looks correct:

```bash
terraform apply
```

---

## Important

Do not blindly apply this reference solution to an existing environment.

Review:

```text
terraform plan
```

first.

The reference solution was built around one specific CloudClimb lab environment.

Resource names, regions, available SKUs, Azure Policies, IP addresses, and subscription restrictions may be different in another environment.

---

## Files That Should Not Be Committed

Do not commit:

```text
terraform.tfvars
terraform.tfstate
terraform.tfstate.backup
.terraform/
Private SSH keys
Database passwords
Azure credentials
.env files containing secrets
```

---

## Production Considerations

The final lab implementation is intentionally different from the preferred production design.

For production, the preferred architecture would normally be closer to:

```text
Same Azure Region

Application Subnet
      |
      v
Application
      |
      | Private traffic
      v
Data Subnet
      |
      v
PostgreSQL
```

Production environments may also include:

- Private PostgreSQL networking
- Private DNS
- Stable outbound networking
- Key Vault or another secrets-management solution
- High Availability
- Backups
- Monitoring
- Alerting
- Remote Terraform state
- CI/CD
- Multiple environments
- Stricter RBAC and policy controls

---

## Key Takeaways

This reference solution demonstrates how:

```text
Terraform
+
Azure Networking
+
Linux
+
Docker
+
Memos
+
PostgreSQL
+
Troubleshooting
```

fit together.

The most important lesson from Week 03 was not simply deploying a database.

It was understanding the full application path:

```text
User
  |
  v
Memos
  |
  v
Linux VM
  |
  v
Network
  |
  v
PostgreSQL
```

and being able to troubleshoot each layer when something does not work.

---

## Reference Solution Note

This is one working implementation.

Participants may have different:

- Naming conventions
- CIDR ranges
- Regions
- VM sizes
- PostgreSQL SKUs
- Terraform file structures
- Troubleshooting experiences

The goal is to understand the architecture and reasoning behind the deployment, not to copy every value exactly.

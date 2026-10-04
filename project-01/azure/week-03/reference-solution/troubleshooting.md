# Week 03 Troubleshooting

This file documents the main issues encountered while completing **CloudClimb Project 01 - Azure Week 03**.

The goal is to show the troubleshooting process, root causes, fixes, and lessons learned while moving from a working Memos container to a PostgreSQL-backed application.

---

# Issue 1 - PostgreSQL Flexible Server Could Not Be Provisioned in East US

## Symptom

Terraform attempted to create Azure Database for PostgreSQL Flexible Server in East US and failed.

Azure returned an error indicating that the location was restricted for provisioning Flexible Servers.

Example:

```text
The location is restricted for provisioning of flexible servers.
Please try using another region.
```

---

## What I Checked

I verified:

- PostgreSQL Flexible Server SKU availability
- PostgreSQL version
- Azure region
- Terraform configuration
- Azure CLI behavior
- Resource provider registration
- Other Azure regions

---

## Root Cause

The Azure subscription being used for the lab was restricted from provisioning PostgreSQL Flexible Server in East US.

The Terraform configuration itself was valid.

---

## Fix

Instead of moving the entire existing environment to another region, I kept the Week 01 and Week 02 infrastructure in East US and deployed PostgreSQL in Central US as a lab workaround.

The existing:

- VNet
- Subnets
- VM
- NIC
- NSGs
- Docker deployment

remained in East US.

---

## Verification

A test PostgreSQL deployment in Central US progressed past the regional restriction.

---

## What I Learned

A cloud service can be supported in a region while still being restricted for a specific subscription.

Service availability and subscription-level provisioning access are not always the same thing.

---

# Issue 2 - Azure Policy Blocked PostgreSQL Deployment

## Symptom

A PostgreSQL deployment in Central US failed with:

```text
RequestDisallowedByPolicy
```

The error referenced:

```text
adminlab-security-baseline
```

and required resource tags.

---

## What I Checked

The Azure Policy error showed that the following tags were required:

```text
Environment
Project
Owner
```

---

## Root Cause

The subscription had an Azure Policy with a `deny` effect requiring specific tags on resources.

The test deployment did not include those tags.

---

## Fix

The required tags were included in the deployment.

Example:

```hcl
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
  Owner       = "YOUR_NAME"
  Project     = "CloudClimb-Project01"
  Purpose     = "CloudClimb-Lab"
}
```

---

## What I Learned

Cloud deployments can fail even when the Terraform or Azure configuration is technically valid if governance requirements are not met.

Azure Policy should be treated as part of the environment design.

---

# Issue 3 - PostgreSQL Server Name Already Existed

## Symptom

Terraform attempted to create the PostgreSQL Flexible Server and Azure returned:

```text
ServerNameAlreadyExists
```

---

## Root Cause

The original server name was already being used.

Azure PostgreSQL Flexible Server names must be unique.

---

## Fix

The PostgreSQL server name was changed from:

```text
cloudclimb-project01-postgres
```

to:

```text
cloudclimb-project01-postgres-dev01
```

Terraform was then run again.

---

## Verification

The PostgreSQL server deployed successfully after using the new name.

---

## What I Learned

Some managed Azure services require globally or service-wide unique names.

Naming conflicts may occur even when the name is not already present in your own resource group.

---

# Issue 4 - Terraform Tried to Change the PostgreSQL Availability Zone

## Symptom

After the PostgreSQL server was created, Terraform returned:

```text
zone can only be changed when exchanged with the zone specified in high_availability
```

---

## Root Cause

Azure automatically selected an Availability Zone for the PostgreSQL server.

Terraform later detected the zone value and attempted to reconcile the difference.

The lab was not using PostgreSQL High Availability.

---

## Fix

The PostgreSQL resource was updated with:

```hcl
lifecycle {
  ignore_changes = [
    zone
  ]
}
```

This tells Terraform not to attempt changes to the automatically assigned zone.

---

## Verification

Terraform was able to complete subsequent applies without attempting to modify the PostgreSQL zone.

---

## What I Learned

Cloud providers sometimes assign properties automatically.

Terraform lifecycle rules can be useful when a provider-managed setting should not be continuously reconciled.

They should be used intentionally and only when the reason is understood.

---

# Issue 5 - SSH Connection Timed Out

## Symptom

SSH to the Linux VM timed out even though Azure showed the VM as running.

Example:

```bash
ssh azureuser@VM_PUBLIC_IP
```

The connection did not complete.

---

## What I Checked

I verified:

- VM power state
- VM Public IP
- Current local public IPv4 address
- Application NSG
- SSH rule
- TCP port 22

---

## Root Cause

The SSH NSG rule was restricted to an older public IP address.

The network I was connecting from had changed, so my current public IP no longer matched the NSG rule.

---

## Fix

I checked my current public IPv4 address:

```bash
curl -4 ifconfig.me
```

Then updated:

```hcl
ssh_source_ip
```

in my local Terraform variables.

Terraform was applied again:

```bash
terraform plan
terraform apply
```

---

## Verification

SSH successfully connected after the NSG source IP was updated.

---

## What I Learned

Restricting SSH to a `/32` source IP is safer than allowing the entire internet, but the rule may need to be updated when changing networks.

---

# Issue 6 - Confusing My Public IP With the VM Public IP

## Symptom

During troubleshooting, there was confusion between:

```text
My laptop/network public IP
```

and:

```text
The Azure VM public IP
```

---

## Root Cause

These addresses serve different purposes.

The local public IP is used as the allowed source in the NSG.

The Azure VM public IP is the destination used when connecting to the VM.

---

## Correct Traffic Flow

```text
My Public IP
      |
      | TCP 22 allowed
      v
Application NSG
      |
      v
Azure VM Public IP
      |
      v
Linux VM
```

---

## What I Learned

The source IP and destination IP are different parts of the same network connection.

For SSH:

```text
Source = my network
Destination = Azure VM
```

---

# Issue 7 - PostgreSQL Port 5432 Timed Out

## Symptom

From inside the Linux VM, this command timed out:

```bash
nc -vz POSTGRES_FQDN 5432
```

---

## What I Checked

I checked:

- PostgreSQL server status
- PostgreSQL FQDN
- DNS resolution
- Public network access
- PostgreSQL firewall rules
- VM outbound public IP
- TCP 5432 connectivity

---

## Root Cause

The PostgreSQL firewall was allowing the wrong source IP.

The firewall had been configured with the public IP of my local network instead of the IP the Azure VM was actually using when connecting outbound.

The database connection originated from the VM, not from my laptop.

---

## Fix

From inside the VM, I checked the outbound IPv4 address:

```bash
curl -4 ifconfig.me
```

The PostgreSQL firewall rule was updated so that the correct VM outbound IP was allowed.

The Terraform firewall rule used:

```hcl
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_app_vm" {
  name             = "Allow-Memos-VM"
  server_id        = azurerm_postgresql_flexible_server.memos.id
  start_ip_address = azurerm_public_ip.app_vm.ip_address
  end_ip_address   = azurerm_public_ip.app_vm.ip_address
}
```

For this lab, the VM's outbound IP matched the attached public IP.

---

## Verification

The following command succeeded:

```bash
nc -vz POSTGRES_FQDN 5432
```

---

## What I Learned

The database firewall must allow the IP of the system actually initiating the connection.

For this project:

```text
Laptop public IP
→ SSH access to VM

VM outbound public IP
→ PostgreSQL access
```

---

# Issue 8 - PostgreSQL Authentication Test

## Goal

After TCP 5432 connectivity succeeded, I needed to confirm that PostgreSQL itself was accepting authentication.

---

## Test

The PostgreSQL client was installed:

```bash
sudo apt update
sudo apt install postgresql-client -y
```

Then I connected using:

```bash
psql \
  --host=POSTGRES_FQDN \
  --username=pgadminuser \
  --dbname=postgres
```

---

## Verification

After logging in, I ran:

```sql
SELECT current_database(), current_user;
```

Then created the application database:

```sql
CREATE DATABASE memos;
```

---

## What I Learned

A successful TCP connection only proves that the network path works.

It does not prove that:

- Credentials are correct
- PostgreSQL authentication works
- The requested database exists

Testing should happen in layers.

---

# Issue 9 - Docker Container Name Already In Use

## Symptom

When starting Memos again, Docker returned:

```text
Conflict. The container name "/memos" is already in use
```

---

## Root Cause

A Memos container already existed on the Linux VM.

Docker requires container names to be unique on the host.

---

## Fix

The existing container was removed:

```bash
docker rm -f memos
```

Memos was then recreated using the PostgreSQL configuration.

---

## Verification

The new container appeared as running:

```bash
docker ps
```

The application logs were checked:

```bash
docker logs memos
```

---

## What I Learned

Container lifecycle should be checked before trying to create a new container with an existing name.

Useful commands include:

```bash
docker ps
docker ps -a
docker logs memos
docker stop memos
docker rm memos
```

---

# Issue 10 - Memos Was Initially Using SQLite

## Symptom

The first working Memos deployment used SQLite rather than PostgreSQL.

---

## Reason

This was intentional.

SQLite was used first to verify:

- Docker worked
- The container started
- Port 5230 worked
- The NSG allowed application access
- Memos could be reached from the browser

---

## Fix / Next Step

After PostgreSQL was working, the SQLite-backed container was removed.

Memos was recreated using:

```text
MEMOS_DRIVER=postgres
```

and:

```text
MEMOS_DSN
```

---

## Verification

Memos loaded successfully in the browser.

A new administrator account was created because the application was now using a new PostgreSQL database rather than the previous SQLite database.

---

## What I Learned

Testing the application with SQLite first helped isolate the application layer before introducing database networking and authentication.

This made troubleshooting easier.

---

# Final Troubleshooting Method

The most useful approach during Week 03 was to troubleshoot one layer at a time.

```text
Is the VM running?
      |
      v
Can I SSH into it?
      |
      v
Is Docker running?
      |
      v
Is the Memos container running?
      |
      v
Can I reach Memos on port 5230?
      |
      v
Does PostgreSQL DNS resolve?
      |
      v
Can I reach TCP 5432?
      |
      v
Can psql authenticate?
      |
      v
Does the memos database exist?
      |
      v
Can Memos authenticate to PostgreSQL?
      |
      v
Does the application work in the browser?
```

This prevented me from changing multiple things at once without knowing which layer was actually failing.

---

# Main Lessons From Week 03

Week 03 reinforced that cloud troubleshooting is not always about fixing bad code.

The issues involved:

- Azure regional restrictions
- Azure Policy
- Resource naming
- Terraform state and drift
- Availability Zones
- NSGs
- Public IPs
- Outbound IPs
- Database firewalls
- DNS
- TCP connectivity
- PostgreSQL authentication
- Docker container lifecycle
- Application configuration

The biggest lesson was to verify each layer independently before moving to the next one.

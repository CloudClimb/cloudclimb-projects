# Project 01 - Azure Week 02
## Application Compute, Network Integration, SSH Access, and Troubleshooting

Welcome to Week 02 of Project 01.

In Week 01, you built the Azure network foundation that the rest of this project will use.

You should already have:

- 1 Resource Group
- 1 Virtual Network
- 1 Application Subnet
- 1 Data Subnet
- 1 Management Subnet
- Network Security Groups
- Consistent naming
- Resource tags
- Basic architecture documentation

This week, you will build directly on top of that environment.

The goal of Week 02 is to add the first application compute resource to the network you already created, secure the way that resource is accessed, use SSH key-based authentication, and work through a small troubleshooting scenario.

Memos will **not** be fully deployed yet.

This week is about preparing the infrastructure that Memos will run on during the next stage of the project.

---

# Scenario

The networking foundation has been completed.

The application team is now ready for compute capacity that can eventually host the Memos application.

Your task is to deploy a Linux workload host into the existing application tier, make sure it is connected to the correct network, restrict unnecessary access, verify that it can communicate as expected, and troubleshoot a connectivity problem without rebuilding the environment.

You are not building a new environment.

You are extending the environment you created in Week 01.

---

# Week 02 Goal

By the end of this week, your Azure environment should progress from:

```text
Week 01

Resource Group
  |
  v
Virtual Network
  |
  +-- Application Subnet
  +-- Data Subnet
  +-- Management Subnet
```

to:

```text
Week 02

Resource Group
  |
  v
Virtual Network
  |
  +-- Application Subnet
  |      |
  |      v
  |   Linux VM
  |
  +-- Data Subnet
  |
  +-- Management Subnet
```

The Linux VM created this week will become the application host used later in Project 01.

---

# What You Will Cover

Week 02 focuses on:

- Azure Virtual Machines
- Network Interfaces
- Subnet placement
- Public and private IP addressing
- Network Security Groups
- SSH access
- SSH key authentication
- Least-privilege network rules
- Outbound connectivity
- Linux administration basics
- Terraform resource relationships
- Troubleshooting network access
- Architecture documentation
- Cost awareness

The goal is not simply to create a VM.

You should understand how that VM fits into the cloud environment you are building and how to troubleshoot it when access does not work as expected.

---

# Time Expectation

Week 02 is designed to take approximately:

**2-3 hours**

Your time may vary depending on:

- Your Azure experience
- Whether you use Terraform or the Azure Portal
- Troubleshooting
- Documentation
- Whether you experiment beyond the required tasks

Understanding what you are building is more important than finishing quickly.

---

# Requirements

You must continue using the resources created during Week 01.

Do not create a completely separate Resource Group or Virtual Network for Week 02.

Your application compute should be connected to the existing **Application Subnet**.

---

# Task 1 - Review Your Week 01 Environment

Before adding new infrastructure, confirm that your Week 01 resources still exist and are configured correctly.

Verify:

- Resource Group exists
- Virtual Network exists
- Application Subnet exists
- Data Subnet exists
- Management Subnet exists
- Network Security Groups exist
- Resource tags are still present

You should understand which subnet will host the application workload before moving forward.

---

# Task 2 - Deploy a Linux Virtual Machine

Deploy one small Linux Virtual Machine that will eventually host Memos.

The VM must be deployed into the **Application Subnet** created during Week 01.

Recommended operating system:

- Ubuntu Server LTS

Use a small VM size suitable for a lab environment.

Do not select an unnecessarily expensive VM size.

Your VM should include:

- Linux operating system
- Network Interface
- Connection to the Application Subnet
- Private IP address
- Appropriate resource naming
- Required project tags

---

# Task 3 - Configure the Network Interface

Your Virtual Machine will communicate with the network through a Network Interface.

Verify that the NIC is connected to:

- Your existing Virtual Network
- Your existing Application Subnet

You should be able to explain:

- What the NIC does
- Why the VM needs one
- Which private IP address was assigned
- Which subnet the NIC belongs to

The VM should not be connected to a newly created or unrelated network.

---

# Task 4 - Configure Management Access

You need a way to securely access the Linux VM for administration.

For this stage of the project, SSH may be used.

SSH uses:

```text
TCP 22
```

If you allow SSH access from the internet, do not allow unrestricted access unless absolutely necessary.

Preferred approach:

```text
Your Public IP
      |
      | TCP 22
      v
Application NSG
      |
      v
Linux VM
```

Avoid:

```text
0.0.0.0/0
TCP 22
Allow
```

when possible.

Restrict the SSH source to your own public IP address.

---

# Task 5 - Create an SSH Key Pair

For this project, SSH key authentication should be used instead of storing a password in Terraform.

Each participant should create their own SSH key pair on their local computer.

An SSH key pair contains:

```text
Private Key  -> stays on your computer
Public Key   -> copied to the Azure VM
```

The private key should never be uploaded to GitHub or shared with anyone.

---

## Check for an Existing SSH Key

Before creating a new key, check whether you already have one.

On macOS or Linux:

```bash
ls ~/.ssh
```

Look for files such as:

```text
id_ed25519
id_ed25519.pub
```

or:

```text
id_rsa
id_rsa.pub
```

The file ending in `.pub` is the public key.

The file without `.pub` is the private key.

---

## Create a New SSH Key

If you do not already have a key pair, create one with:

```bash
ssh-keygen -t ed25519
```

When prompted for the file location, you may press Enter to accept the default:

```text
~/.ssh/id_ed25519
```

You will also be asked whether you want to use a passphrase.

Using a passphrase provides additional protection for your private key, but it is optional for this lab.

After the key is created, verify that both files exist:

```bash
ls ~/.ssh
```

You should see:

```text
id_ed25519
id_ed25519.pub
```

---

## Use the Public Key with Terraform

If you are using Terraform, your Linux VM configuration can reference the public key.

Example:

```hcl
admin_username = "azureuser"

admin_ssh_key {
  username   = "azureuser"
  public_key = file("~/.ssh/id_ed25519.pub")
}
```

This tells Terraform to read your public key and configure it for the `azureuser` account on the VM.

The username in:

```hcl
admin_username
```

should match the username in:

```hcl
admin_ssh_key
```

---

## Why Use SSH Keys?

SSH keys are preferred over passwords because they avoid placing reusable passwords inside Terraform files or other configuration.

The authentication flow looks like:

```text
Your Computer
     |
     | Private Key
     |
     v
SSH Authentication
     |
     v
Azure Linux VM
     |
     | Public Key
```

Azure receives the public key.

Your private key remains on your local computer.

---

## Important Security Reminder

Never commit or upload your private SSH key.

Do not upload files such as:

```text
id_ed25519
id_rsa
```

The public key files:

```text
id_ed25519.pub
id_rsa.pub
```

are not secret, but the private keys must remain protected.

Each participant should use their own SSH key instead of sharing one CloudClimb key.

---

# Task 6 - Review Your Network Security Group

Review the Network Security Group associated with your Application Subnet or VM Network Interface.

Your NSG should allow only the traffic required for the current stage of the project.

For Week 02, you may need:

```text
SSH
TCP 22
Your Public IP -> Linux VM
```

Do not open application ports that are not required yet.

Memos is not being deployed this week, so there is no reason to expose its application port yet.

The goal is to practice least-privilege access.

---

# Task 7 - Connect to the Linux VM

Once the VM has been deployed, connect to it using SSH.

Example:

```bash
ssh username@PUBLIC_IP
```

If your Terraform configuration uses:

```text
azureuser
```

as the administrator username, the command would look like:

```bash
ssh azureuser@PUBLIC_IP
```

The public IP in this command is the **Azure VM's Public IP**, not your own public IP.

Your own public IP is used in the NSG rule as the allowed source.

Think of it like this:

```text
Your Public IP
     |
     | Allowed Source
     v
Application NSG
     |
     v
Azure VM Public IP
     |
     v
Linux VM
```

Once connected, confirm that you can successfully access the Linux shell.

---

# Task 8 - Verify the VM

After connecting to the VM, perform a few basic checks.

Examples:

```bash
hostname
```

```bash
ip addr
```

```bash
uname -a
```

```bash
df -h
```

```bash
free -h
```

These commands help you verify basic information about the system.

You are not expected to become a Linux administrator during this project.

The goal is simply to become comfortable interacting with the workload host.

---

# Task 9 - Verify Outbound Connectivity

The VM will eventually need outbound connectivity to download packages, container images, and other dependencies.

Verify that the VM can reach the internet.

For example:

```bash
curl https://example.com
```

or:

```bash
sudo apt update
```

If outbound connectivity fails, troubleshoot the issue.

Review:

- Subnet configuration
- Routing
- Network Security Groups
- Public IP configuration
- Azure platform behavior

Do not immediately rebuild the environment.

Use the issue as a troubleshooting exercise.

---

# Task 10 - Troubleshooting Challenge

Part of cloud engineering is being able to diagnose problems when infrastructure exists but does not behave as expected.

For this challenge, intentionally create a small SSH connectivity issue and troubleshoot it.

## Scenario

Your Linux VM is running, but you can no longer connect to it over SSH.

The VM itself has not failed.

Your task is to determine what is preventing the connection and restore access without rebuilding the VM.

You may intentionally create the issue by changing one of the following:

- Remove the SSH allow rule
- Restrict the SSH source to an incorrect IP address
- Create a higher-priority deny rule
- Associate the wrong NSG
- Remove the Public IP from the access path

Only introduce **one** issue.

The goal is to practice troubleshooting, not make the environment impossible to recover.

---

## Troubleshooting Process

Work through the connection path instead of guessing.

```text
Your Computer
     |
     v
Internet
     |
     v
Public IP
     |
     v
NSG
     |
     v
NIC
     |
     v
Linux VM
```

Check each layer.

Ask:

- Is the VM running?
- Does the VM still have the expected Public IP?
- Is the NIC attached correctly?
- Is the NIC in the correct subnet?
- Which NSG is currently applied?
- Is TCP 22 allowed?
- What source IP is allowed?
- Is there a deny rule with a higher priority?
- Did your own public IP change?
- Are you using the correct SSH username and key?

Do not delete and recreate the VM as your first troubleshooting step.

Identify the failure, correct it, and confirm that SSH works again.

---

# Troubleshooting Documentation

Create a separate file named:

```text
troubleshooting.md
```

Use it to document the issue you created and how you resolved it.

Your file should include:

```markdown
# Week 02 Troubleshooting

## Symptom

Describe what stopped working.

## What I Checked

List the areas you investigated.

## Root Cause

Explain what was actually causing the problem.

## Fix

Explain what you changed to restore connectivity.

## Verification

Explain how you confirmed the issue was resolved.

## What I Learned

Briefly explain what this issue taught you about Azure networking or troubleshooting.
```

This document does not need to be long.

The goal is to practice documenting a technical issue clearly.

---

# Task 11 - Update Your Architecture Diagram

Update the architecture diagram you created during Week 01.

Your diagram should now include:

- Resource Group
- Virtual Network
- Application Subnet
- Data Subnet
- Management Subnet
- Network Security Groups
- Linux Virtual Machine
- Network Interface
- Public IP if one is being used

Example:

```text
Internet
   |
   | SSH
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
Network Interface
   |
   v
Linux VM
```

Your actual diagram should also show the remaining Week 01 subnets.

---

# Terraform Option

Terraform is strongly encouraged but not required for Week 02.

If you used Terraform during Week 01, continue using the same configuration rather than starting a completely unrelated Terraform project.

You may add resources such as:

```text
azurerm_public_ip
azurerm_network_interface
azurerm_network_security_rule
azurerm_linux_virtual_machine
```

Your existing resources should continue to be managed alongside the new infrastructure.

A simple configuration is completely acceptable.

You are not required to use Terraform modules yet.

---

# Azure Portal Option

If you are using the Azure Portal, deploy the same required infrastructure manually.

The final environment should meet the same requirements regardless of whether you use Terraform or the Portal.

Portal users should still understand:

- Which subnet the VM uses
- Which NSG protects it
- Which traffic is allowed
- Which traffic is blocked
- How the VM receives an IP address
- How administrators connect to the VM
- Why SSH key authentication is being used

The Portal is a deployment method.

The architecture requirements remain the same.

---

# Naming and Tagging

Continue using the naming and tagging standards established during Week 01.

Example resource names might include:

```text
cloudclimb-project01-app-vm
cloudclimb-project01-app-nic
cloudclimb-project01-app-pip
```

Your exact naming convention may differ.

Consistency is more important than matching the example exactly.

Continue applying useful tags such as:

```text
Environment = Development
Project     = CloudClimb-Project01
ManagedBy   = Terraform
```

Adjust the `ManagedBy` value if you are using the Azure Portal.

---

# Security Considerations

Before finishing Week 02, review the security of your VM.

Ask yourself:

- Is SSH open to everyone?
- Could I restrict the SSH source?
- Is the VM in the correct subnet?
- Does the NSG allow unnecessary ports?
- Does the VM require a public IP?
- Are there credentials stored in Terraform files?
- Am I using password authentication or SSH keys?
- Is my private SSH key protected?
- Are there resources exposed that do not need to be exposed?

You do not need to design a perfect production environment yet.

You should begin developing the habit of questioning unnecessary access.

---

# Cost Awareness

Virtual Machines can create ongoing charges.

Use a small VM size appropriate for a learning environment.

After you finish working for the day, consider stopping or deallocating the VM if you do not need it running.

Remember:

Stopping Linux from inside the VM does not always mean Azure has stopped billing for the underlying compute allocation.

Verify the VM status in Azure.

You can deallocate the VM with Azure CLI:

```bash
az vm deallocate \
  --resource-group YOUR_RESOURCE_GROUP \
  --name YOUR_VM_NAME
```

You can start it again later with:

```bash
az vm start \
  --resource-group YOUR_RESOURCE_GROUP \
  --name YOUR_VM_NAME
```

Also review any charges related to:

- VM compute
- Managed disks
- Public IP addresses
- Additional networking services

Do not deploy expensive resources for this project unless they are required.

---

# What Not to Deploy Yet

Week 02 does not require:

- Memos
- PostgreSQL
- Azure Database for PostgreSQL
- Application Gateway
- Load Balancer
- Azure Bastion
- Key Vault
- Private Endpoints
- CI/CD
- GitHub Actions
- Azure Monitor configuration
- Kubernetes
- Complex Terraform modules

Those concepts will either be introduced later or are outside the scope of this stage.

Keep the environment simple.

---

# Acceptance Criteria

Week 02 is complete when:

- Your Week 01 Resource Group still exists
- Your Week 01 Virtual Network is still being used
- Your Application Subnet is still being used
- A Linux Virtual Machine has been deployed
- The VM is connected to the Application Subnet
- A Network Interface is attached to the VM
- The VM has a private IP address
- A Public IP is available for SSH if using direct public access
- SSH key authentication is configured
- SSH access works
- SSH access is reasonably restricted
- Required NSG rules are configured
- Unnecessary inbound ports are not exposed
- Outbound internet connectivity works
- You intentionally created and resolved one connectivity issue
- `troubleshooting.md` documents the problem and fix
- Naming is consistent
- Required tags are present
- Your architecture diagram has been updated
- You can explain how traffic reaches the VM

---

# Questions You Should Be Able to Answer

Before considering Week 02 complete, make sure you can answer:

1. What is the purpose of the Application Subnet?

2. Why did you place the VM inside the Application Subnet?

3. What does the Network Interface do?

4. What is the difference between the VM's private IP and public IP?

5. What role does the NSG play?

6. Why should SSH not normally be open to the entire internet?

7. What is the difference between your own public IP and the VM's public IP?

8. What is an SSH key pair?

9. What is the difference between the public SSH key and private SSH key?

10. Why should the private key never be uploaded to GitHub?

11. How does your computer reach the VM?

12. How does the VM reach the internet?

13. What resources from Week 01 are being reused?

14. What issue did you introduce during the troubleshooting challenge?

15. How did you identify the root cause?

16. Why did the configuration prevent SSH access?

17. Why are we not deploying PostgreSQL yet?

18. Why are we not deploying Memos yet?

19. What will this VM be used for during Week 03?

---

# Deliverables

Your Week 02 deliverables should include:

- Updated architecture diagram
- Evidence that the Linux VM was deployed
- Evidence that the VM is using the Application Subnet
- Evidence that SSH connectivity works
- NSG configuration
- Short explanation of your network and security decisions
- `troubleshooting.md`
- Terraform configuration if Terraform was used
- Notes about any other major troubleshooting performed

Do not commit sensitive information to GitHub.

Avoid committing:

```text
terraform.tfstate
terraform.tfstate.backup
.terraform/
Sensitive .tfvars files
Private SSH keys
Passwords
Azure credentials
```

Private SSH keys such as:

```text
id_ed25519
id_rsa
```

should remain on your local computer.

---

# Reference Solution

The official CloudClimb Azure Week 02 reference solution will not be released at the beginning of the week.

Participants should attempt the project requirements themselves first.

After Week 02 is completed, the reference implementation may be released so participants can compare their environment against one working solution.

The reference solution is not the only correct way to complete the project.

Different implementations are acceptable as long as the project requirements and acceptance criteria are met.

---

# Looking Ahead

At the end of Week 02, you should now have:

```text
Azure Network
     |
     v
Application Subnet
     |
     v
Linux VM
```

During Week 03, this environment will begin supporting the actual application workload.

The next stage will introduce:

```text
Linux VM
   |
   v
Container Runtime
   |
   v
Memos
   |
   v
PostgreSQL
```

The infrastructure you created during Week 01 and Week 02 will continue to be used.

The goal is to keep building the same environment instead of starting over every week.

---

# Week 02 Outcome

By the end of this week, you should understand more than how to deploy a Virtual Machine.

You should understand:

- Why the VM belongs in the Application Subnet
- How Azure connects the VM to the network
- How NSGs control traffic
- How administrators securely reach the VM
- How SSH key authentication works
- Why the private key must remain protected
- How your own public IP differs from the VM's public IP
- How the VM reaches external services
- How to troubleshoot an SSH connectivity failure
- How to document a technical issue
- How Week 01 networking supports Week 02 compute
- How this infrastructure will support Memos later

That progression from networking to compute to secure access to troubleshooting is the main goal of Azure Week 02.

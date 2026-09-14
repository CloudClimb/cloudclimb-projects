# Project 01 - AWS Week 02
## Application Compute, Network Integration, and Troubleshooting

Welcome to Week 02 of Project 01.

In Week 01, you built the AWS network foundation that the rest of this project will use.

You should already have:

- 1 VPC
- 2 Application Subnets across 2 Availability Zones
- 2 Data Subnets across 2 Availability Zones
- 2 Management Subnets across 2 Availability Zones
- Internet Gateway
- Public and private route tables
- Security Groups
- Consistent naming
- Resource tags
- Basic architecture documentation

This week, you will build directly on top of that environment.

The goal of Week 02 is to add the first application compute resource to the network you already created, secure the way that resource is accessed, and work through a small troubleshooting scenario.

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

By the end of this week, your AWS environment should progress from:

```text
Week 01

VPC
  |
  +-- Availability Zone A
  |     |
  |     +-- Application Subnet
  |     +-- Data Subnet
  |     +-- Management Subnet
  |
  +-- Availability Zone B
        |
        +-- Application Subnet
        +-- Data Subnet
        +-- Management Subnet
```

to:

```text
Week 02

VPC
  |
  +-- Availability Zone A
  |     |
  |     +-- Application Subnet
  |     |      |
  |     |      v
  |     |   Linux EC2 Instance
  |     |
  |     +-- Data Subnet
  |     +-- Management Subnet
  |
  +-- Availability Zone B
        |
        +-- Application Subnet
        +-- Data Subnet
        +-- Management Subnet
```

The EC2 instance should be deployed into one of the existing Application Subnets.

You are not required to deploy an EC2 instance into both Availability Zones during Week 02.

The second Application Subnet remains available for later stages of the project.

---

# Time Expectation

Week 02 should take approximately:

```text
2-3 hours
```

depending on your experience level and whether you use Terraform or the AWS Console.

Take longer if needed.

The goal is understanding the environment, not rushing through it.

---

# Week 02 Requirements

You must reuse your Week 01 infrastructure.

Do not create a separate VPC for Week 02.

Your existing network should continue to contain:

- Application Subnets
- Data Subnets
- Management Subnets
- Route Tables
- Internet Gateway
- Security Groups

This week, you will add:

- 1 Linux EC2 Instance
- EC2 network interface
- Private IP address
- Public access path for SSH
- SSH access controls
- Updated architecture documentation
- Troubleshooting documentation

---

# Task 1 - Verify Your Week 01 Environment

Before deploying anything new, confirm that your Week 01 resources still exist and are working.

Verify:

- VPC
- Application Subnets
- Data Subnets
- Management Subnets
- Internet Gateway
- Public Route Table
- Private Route Table
- Route Table Associations
- Security Groups
- Resource tags

Make sure you understand which Application Subnets are public and which subnets are private.

Your EC2 instance should be placed in an existing Application Subnet.

---

# Task 2 - Deploy a Linux EC2 Instance

Deploy one Linux EC2 instance into an existing Application Subnet.

Recommended operating systems:

- Ubuntu Server LTS
- Amazon Linux

Use a small instance size appropriate for a learning environment.

Examples may include:

```text
t3.micro
```

or another low-cost instance type available in your account.

Your instance should have:

- A private IP address
- A network interface in the Application Subnet
- A Security Group
- SSH access
- A key pair
- A public IP address if you are using direct SSH access

Example name:

```text
cloudclimb-project01-app-ec2
```

Use naming and tagging that match your Week 01 environment.

Suggested tags:

```text
Project     = CloudClimb-Project01
Environment = Development
ManagedBy   = Terraform
```

If you are using the AWS Console, adjust the `ManagedBy` value accordingly.

---

# Task 3 - Confirm Network Placement

Verify that the EC2 instance is actually deployed into the correct Application Subnet.

You should be able to identify:

- VPC ID
- Subnet ID
- Availability Zone
- Private IP address
- Public IP address if used
- Attached Security Group

Do not simply assume the instance was deployed to the correct location.

Verify it.

You should be able to explain why the instance belongs in the Application tier instead of the Data or Management tier.

---

# Task 4 - Secure SSH Access

Your Linux EC2 instance must be reachable for administration.

For Week 02, direct SSH access is acceptable.

Allow:

```text
TCP 22
```

Restrict SSH access to your current public IP address whenever possible.

Example:

```text
YOUR_PUBLIC_IP/32
```

Avoid:

```text
0.0.0.0/0
```

for SSH unless temporarily required for troubleshooting.

Your Security Group should follow least privilege.

Only open the ports required for the current stage of the project.

---

# Task 5 - Connect to the EC2 Instance

Connect to the instance using SSH.

Example for Ubuntu:

```bash
ssh -i your-key.pem ubuntu@PUBLIC_IP
```

Example for Amazon Linux:

```bash
ssh -i your-key.pem ec2-user@PUBLIC_IP
```

Once connected, run basic Linux commands.

Examples:

```bash
hostname
ip addr
uname -a
df -h
free -h
```

You should understand what these commands tell you about the system.

The goal is not advanced Linux administration.

The goal is to verify that the workload host is running and accessible.

---

# Task 6 - Verify Outbound Connectivity

From inside the EC2 instance, verify that it can reach the internet.

Examples:

```bash
curl https://example.com
```

Ubuntu:

```bash
sudo apt update
```

Amazon Linux:

```bash
sudo dnf check-update
```

If outbound connectivity fails, investigate the full network path.

Think about:

```text
EC2 Instance
   |
   v
Application Subnet
   |
   v
Public Route Table
   |
   v
Internet Gateway
   |
   v
Internet
```

Also verify:

- The instance has a public IP if required
- The Application Subnet is associated with the Public Route Table
- The Public Route Table has a default route to the Internet Gateway
- The Internet Gateway is attached to the VPC
- Security Group egress allows the required traffic

---

# Task 7 - Review Security

Review the security configuration around your EC2 instance.

Ask yourself:

- Is SSH restricted to my IP?
- Are unnecessary inbound ports open?
- Is the correct Security Group attached?
- Is the instance in the correct subnet?
- Does the instance actually need a public IP?
- Are Data and Management subnets still protected from unnecessary public access?

Do not open additional application or database ports unless required by the current Week 02 task.

Future weeks will introduce those requirements when they are needed.

---

# Task 8 - Update Your Architecture Diagram

Update your Week 01 architecture diagram to include the new EC2 instance.

Your updated diagram should clearly show:

```text
Internet
   |
   v
Internet Gateway
   |
   v
Public Route Table
   |
   v
Application Subnet
   |
   v
Linux EC2 Instance
```

Your full environment should still show:

```text
VPC
├── Availability Zone A
│   ├── Application Subnet
│   │   └── Linux EC2 Instance
│   ├── Data Subnet
│   └── Management Subnet
│
└── Availability Zone B
    ├── Application Subnet
    ├── Data Subnet
    └── Management Subnet
```

Your diagram does not need to look exactly like this.

The goal is to clearly show how the new compute resource fits into the existing network.

---

# Task 9 - Intentional Troubleshooting Challenge

After you successfully connect to the EC2 instance, intentionally create one SSH connectivity issue.

Choose only one issue at a time.

Examples:

- Remove the SSH inbound rule
- Change the SSH source to the wrong IP
- Attach the wrong Security Group
- Remove the public IP from the access path
- Associate the Application Subnet with the wrong Route Table
- Remove the default route to the Internet Gateway

After creating the issue, attempt to connect again.

The connection should fail.

Your job is to troubleshoot the problem without deleting and rebuilding the EC2 instance.

---

# Troubleshooting Process

Think through the full connection path:

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
Internet Gateway
   |
   v
Route Table
   |
   v
Application Subnet
   |
   v
Security Group
   |
   v
EC2 Instance
```

Investigate:

1. Is the EC2 instance running?
2. Does it have the expected public IP?
3. Is it in the correct Application Subnet?
4. Is the subnet associated with the correct Route Table?
5. Does the Route Table have a route to the Internet Gateway?
6. Is the Internet Gateway attached to the VPC?
7. Is the correct Security Group attached?
8. Does the Security Group allow TCP 22?
9. Is your current public IP allowed?
10. Are you using the correct SSH username?
11. Are you using the correct private key?

Do not randomly change settings.

Identify the root cause first.

---

# Task 10 - Create `troubleshooting.md`

Create a separate file called:

```text
troubleshooting.md
```

Use the following structure:

```markdown
# Week 02 Troubleshooting

## Symptom

Describe what stopped working.

## What I Checked

List the areas you investigated.

## Root Cause

Explain the actual cause.

## Fix

Explain what you changed to restore connectivity.

## Verification

Explain how you confirmed the issue was resolved.

## What I Learned

Briefly explain what you learned about AWS networking or troubleshooting.
```

The goal is to document the issue like a real infrastructure problem.

---

# Terraform Track

Terraform is still optional for Week 02, but it is encouraged.

If you used Terraform during Week 01, continue using the same Terraform configuration.

Do not create a completely unrelated environment.

You may add resources such as:

```text
aws_instance
```

Depending on your design, you may also modify or add:

```text
aws_security_group
aws_security_group_rule
```

You may also need to reference:

```text
aws_subnet
aws_vpc
```

from your existing Week 01 configuration.

Terraform modules are not required this week.

Keep the configuration readable and understandable.

Your progression should look something like:

```text
Week 01

VPC
Subnets
Route Tables
Internet Gateway
Security Groups

        +

Week 02

EC2 Instance
SSH Access
Compute Network Integration
```

Before deploying:

```bash
terraform fmt
terraform validate
terraform plan
```

Review the plan carefully before running:

```bash
terraform apply
```

---

# AWS Console Track

If you are using the AWS Console, you must reach the same final architecture and security outcome.

You should understand:

- Which VPC you selected
- Which Application Subnet you selected
- Which Availability Zone the instance is in
- Which Security Group is attached
- How SSH reaches the instance
- How the instance reaches the internet
- Which Route Table is associated with the subnet

Do not accept defaults without understanding what they do.

---

# Cost Awareness

Week 02 introduces an EC2 instance, which can generate cloud costs.

Use a small instance type.

Stop or terminate resources you no longer need.

Be aware that stopping an EC2 instance may stop compute charges, but other resources may continue generating charges.

Examples may include:

- EBS volumes
- Public IPv4 addresses
- Snapshots
- Other attached services

Review current AWS pricing and your billing dashboard.

You are responsible for resources deployed into your own AWS account.

---

# Not Yet

Do not deploy the following during Week 02:

- Memos
- PostgreSQL
- Amazon RDS
- Application Load Balancer
- NAT Gateway
- ECS
- EKS
- Secrets Manager
- CI/CD
- GitHub Actions
- Advanced monitoring
- Complex Terraform modules

These will be introduced later when they are required.

---

# Acceptance Criteria

Week 02 is complete when:

- Your Week 01 VPC is still being used
- Your existing Application Subnet is reused
- One Linux EC2 instance is deployed
- The instance is in the correct Application Subnet
- The instance has a private IP
- SSH access works
- SSH access is reasonably restricted
- The correct Security Group is attached
- Unnecessary inbound ports are closed
- Outbound internet connectivity works
- Naming and tags are applied
- Your architecture diagram is updated
- You intentionally create one connectivity problem
- You diagnose the root cause
- You restore connectivity without rebuilding the instance
- You create `troubleshooting.md`

---

# Deliverables

Save the following as evidence of your Week 02 work:

- Updated architecture diagram
- EC2 deployment evidence
- Evidence showing the EC2 instance is in the Application Subnet
- Security Group configuration
- SSH connection evidence
- Basic Linux command output
- Outbound connectivity verification
- Short architecture/security notes
- `troubleshooting.md`
- Terraform files if Terraform was used

Your exact documentation format is up to you.

The goal is to be able to show and explain what you built.

---

# Reference Solution

The CloudClimb reference solution will not be released while Week 02 is active.

Complete the requirements first.

Research problems.

Troubleshoot your own environment.

Use the AWS troubleshooting channel when needed.

After the week closes, a tested reference solution will be released for comparison.

The reference solution represents one valid implementation, not the only possible solution.

---

# Looking Ahead - Week 03

In Week 03, the compute layer you created this week will begin hosting the actual application workload.

The environment will progress toward:

```text
Linux EC2
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

Your Week 01 network and Week 02 compute infrastructure will continue to be reused.

Do not tear down the environment if you plan to continue into Week 03.

---

# Week 02 Outcome

By the end of Week 02, you should understand how to take an existing AWS network and place an application workload host into it correctly.

More importantly, you should be able to explain:

```text
Where the EC2 instance belongs
Why it belongs there
How SSH reaches the instance
How outbound traffic leaves the VPC
How Security Groups control access
How Route Tables affect connectivity
How to troubleshoot when access breaks
```

That is the real goal of Week 02.

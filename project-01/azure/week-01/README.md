# Week 1 - Build the Azure Network Foundation

## Scenario

CloudClimb is preparing to deploy **Memos**, an open-source self-hosted note-taking application.

Later in Project 01, Memos will connect to a separate **PostgreSQL database using Azure Database for PostgreSQL**.

Before any application, database, or compute resources are deployed, the cloud engineering team needs to build the Azure network foundation that will support the environment throughout the project.

You are **not deploying Memos, PostgreSQL, compute resources, a load balancer, or a NAT Gateway during Week 1**.

Your task is to design and deploy the Azure network that those resources will eventually use.

---

## Objective

Create a segmented Azure network that can later support:

- Application resources
- Private database/backend resources
- Private management/administrative resources
- Future public application access at the resource or service level

The network created this week will continue to be used and expanded throughout Project 01.

This is not a disposable lab.

---

## Requirements

Your Azure environment must include:

- One Resource Group
- One Virtual Network
- One application subnet
- One data/backend subnet
- One management subnet
- Network Security Groups
- Appropriate routing
- A documented CIDR/IP addressing plan
- Consistent resource naming
- Project/environment tags
- A simple architecture diagram

Your subnet ranges must not overlap.

### Week 1 should NOT include:

- Azure NAT Gateway
- Azure Firewall
- Azure Bastion
- Virtual Machines
- Load Balancer
- Application Gateway
- Azure Database for PostgreSQL

These services may be introduced later if the architecture actually requires them.

---

## Why Azure Uses One Subnet Per Tier

Azure networking works differently from AWS.

In AWS, a subnet belongs to a single Availability Zone, so the AWS track needs duplicate subnets across multiple Availability Zones.

Azure subnets are **regional** and are not tied to one Availability Zone.

Because of that, the Azure track does not need duplicate subnets such as:

```text
app-zone-1
app-zone-2
data-zone-1
data-zone-2
```

for Week 1.

Instead, the Azure environment will use three logical network segments:

```text
Virtual Network
│
├── Application Subnet
├── Data Subnet
└── Management Subnet
```

Availability Zone decisions will be handled later at the individual resource or service level where supported.

---

## Planned Network Layout

Your Week 1 network should follow this general structure:

```text
Resource Group
│
└── Virtual Network
    │
    ├── Application Subnet
    │
    ├── Data Subnet
    │
    └── Management Subnet
```

The actual application, database, and public-facing application services will be introduced in later weeks.

---

## Public vs Private Access

Azure does not make a subnet "public" or "private" in exactly the same way AWS does.

Public access is usually determined by the resources deployed into the subnet, whether those resources receive public endpoints or public IP addresses, and the security rules controlling access.

For Week 1, all three subnets should be designed as **private network segments by default**.

### Application Subnet

The application subnet will eventually support the Memos application or related application resources.

Memos should not automatically be exposed directly to the internet.

Later in the project, public access will be introduced through the Azure service or application entry point selected for the architecture.

### Data Subnet

The data subnet will eventually support the PostgreSQL data tier.

The database should remain private and should not be directly exposed to the public internet.

This subnet should be planned with future **Azure Database for PostgreSQL private networking** in mind.

Depending on the PostgreSQL deployment model selected later, the subnet may require delegation or other service-specific configuration.

### Management Subnet

The management subnet is reserved for administrative or management-related resources that may be introduced later in Project 01.

It should remain private.

---

## Memos and PostgreSQL

Memos can use SQLite by default.

SQLite stores application data in a local database file that lives with the application.

For Project 01, we are instead planning to use **PostgreSQL as a separate database tier**.

In Azure, the planned database service is:

**Azure Database for PostgreSQL**

This gives the project a real application-to-database architecture and allows later weeks to cover:

- Private database connectivity
- Application-to-database networking
- Network Security Group rules
- Database credentials
- Secrets management
- Private DNS
- Backups
- Monitoring
- Troubleshooting

Azure Database for PostgreSQL is **not deployed during Week 1**.

The data subnet created this week prepares the environment for the future database tier.

---

## Azure Services

Week 1 will primarily involve:

- Resource Groups
- Virtual Networks
- Subnets
- Network Security Groups
- Resource Tags

Route Tables / User Defined Routes may be added if your design has a specific reason for them, but custom routes are not required just for the sake of creating them.

---

## NAT Gateway

**Do not deploy an Azure NAT Gateway during Week 1.**

Nothing required during Week 1 needs dedicated outbound internet connectivity from the private subnets.

Adding a NAT Gateway now would introduce unnecessary cost without solving a current requirement.

The goal this week is only to build the network foundation.

When outbound connectivity becomes necessary later in Project 01, we will evaluate the correct solution based on the actual application architecture.

That may include:

- Azure NAT Gateway
- Private Endpoints
- Service-specific networking
- Other Azure-native connectivity options

Do not deploy a NAT Gateway simply because it is available.

If a later requirement actually needs one, it will be introduced at that time.

---

## CIDR Planning

You are responsible for choosing and documenting your own valid CIDR ranges.

Example only:

```text
VNet:        10.10.0.0/16

Application: 10.10.1.0/24
Data:        10.10.2.0/24
Management:  10.10.3.0/24
```

You do not have to use these exact ranges.

Your design should:

- Avoid overlapping CIDR ranges
- Leave room for future growth
- Clearly identify the purpose of each subnet
- Reserve enough address space for resources that may be introduced later

---

## Routing

Azure automatically provides system routes for a Virtual Network.

For Week 1, you should understand and review how traffic is routed instead of creating custom routes without a reason.

Consider:

- How traffic moves between subnets
- Whether a resource needs internet connectivity
- Whether future database traffic should remain private
- Whether custom routing is actually necessary
- Why a NAT Gateway is not needed yet

Route Tables / User Defined Routes should only be created when they serve a real architectural purpose.

---

## Network Security

Network Security Groups should be used to begin establishing network boundaries between tiers.

At minimum, think about:

- Which tiers should eventually communicate?
- Should the database accept traffic from anything other than the application tier?
- Should management traffic be separated from application traffic?
- Which inbound traffic should be denied?
- Does a resource actually need public access?
- Does a resource actually need outbound internet access?

Avoid broad allow-all rules unless there is a clear reason for them.

The goal is not to create a perfect production security model during Week 1.

The goal is to understand why the network is segmented and prepare it for the security controls introduced later.

---

## Cost Guardrails

Week 1 should cost little to nothing.

You should not need to deploy:

- Virtual Machines
- Azure NAT Gateway
- Azure Firewall
- Azure Bastion
- Application Gateway
- Load Balancer
- Azure Database for PostgreSQL
- Other paid compute or managed services

during Week 1.

Always review Azure pricing before deploying anything beyond the requirements.

---

## Infrastructure as Code

Terraform is encouraged but not required during Week 1.

If you are still learning Azure networking, you may build the environment through the Azure Portal.

If you are comfortable with Terraform, you are encouraged to deploy the Week 1 infrastructure using Infrastructure as Code.

Terraform will become a larger part of Project 01 as the environment grows.

---

## Deliverables

By the end of Week 1, provide:

- [ ] Architecture diagram
- [ ] VNet CIDR range
- [ ] Complete subnet/CIDR plan
- [ ] Evidence showing the deployed Resource Group
- [ ] Evidence showing the Virtual Network
- [ ] Evidence showing all three required subnets
- [ ] Evidence showing Network Security Groups
- [ ] Evidence showing NSG-to-subnet associations where applicable
- [ ] Explanation of routing behavior
- [ ] Resource naming convention
- [ ] Tags used
- [ ] Short explanation of why Azure only requires one subnet per logical tier
- [ ] Short explanation of the private network design
- [ ] Short explanation of why a NAT Gateway was not deployed
- [ ] Short explanation of your security decisions
- [ ] Any issue you encountered and how you approached or resolved it

---

## Acceptance Criteria

Week 1 is complete when:

- [ ] One Resource Group has been created for Project 01
- [ ] One Virtual Network has been successfully deployed
- [ ] One application subnet exists
- [ ] One data subnet exists
- [ ] One management subnet exists
- [ ] Every subnet has a documented CIDR range
- [ ] Subnet ranges do not overlap
- [ ] Network Security Groups are configured where appropriate
- [ ] NSGs are associated with the intended subnets where applicable
- [ ] Routing behavior has been reviewed and understood
- [ ] No unnecessary public exposure has been introduced
- [ ] No Azure NAT Gateway has been deployed
- [ ] Resources follow a consistent naming convention
- [ ] Project/environment tags are applied where supported
- [ ] An architecture diagram has been created
- [ ] You can explain the purpose of the major Azure resources you deployed

---

## Engineering Questions

Before deploying a resource, ask yourself:

- What problem does this resource solve?
- Why does this subnet exist?
- Why doesn't Azure need duplicate subnets for each Availability Zone?
- Which tiers should eventually communicate?
- How will Memos fit into this architecture later?
- How will Memos privately connect to PostgreSQL?
- Which resource should eventually receive public access?
- Does this resource actually need internet access?
- Why are we not using a NAT Gateway yet?
- Is this resource necessary during Week 1?
- What will it cost if I leave it deployed?

There is more than one correct way to complete this assignment.

The goal is to understand the network you are building and create a foundation that can continue to grow throughout Project 01.

---

## What's Next?

The network created during Week 1 will remain in place for later stages of Project 01.

Future weeks will introduce:

- The Memos application
- Application hosting
- Public application access
- Azure Database for PostgreSQL
- Private application-to-database connectivity
- Identity and access controls
- Monitoring and troubleshooting
- Terraform and automation

If outbound internet connectivity from private resources becomes necessary later, we will decide at that point whether an Azure NAT Gateway or another Azure networking option is appropriate.

Build Week 1 with the expectation that you will continue using and improving this environment.

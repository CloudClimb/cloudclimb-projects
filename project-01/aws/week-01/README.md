# Week 1 - Build the AWS Network Foundation

## Scenario

CloudClimb is preparing to deploy **Memos**, an open-source self-hosted note-taking application.

Later in Project 01, Memos will connect to a separate **PostgreSQL database using Amazon RDS for PostgreSQL**.

Before any application, database, or compute resources are deployed, the cloud engineering team needs to build the AWS network foundation that will support the environment throughout the project.

You are **not deploying Memos, PostgreSQL, compute resources, a load balancer, or a NAT Gateway during Week 1**.

Your task is to design and deploy the AWS network that those resources will eventually use.

---

## Objective

Create a segmented AWS network across two Availability Zones that can later support:

- Public application resources
- Private database/backend resources
- Private management/administrative resources
- Future load-balanced application access

The network created this week will continue to be used and expanded throughout Project 01.

This is not a disposable lab.

---

## Requirements

Your AWS environment must include:

- One VPC
- At least two Availability Zones
- Two public application subnets, one in each Availability Zone
- Two private data/backend subnets, one in each Availability Zone
- Two private management subnets, one in each Availability Zone
- One Internet Gateway
- Appropriate route tables and routing
- Network Security Groups / Security Groups
- A documented CIDR/IP addressing plan
- Consistent resource naming
- Project/environment tags
- A simple architecture diagram

Your subnet ranges must not overlap.

### Week 1 should NOT include:

- NAT Gateway
- EC2 instances
- ECS services or other application compute
- Application Load Balancer
- Amazon RDS for PostgreSQL
- AWS Network Firewall
- Other paid compute or managed services not required for the network foundation

These services may be introduced later if the architecture actually requires them.

---

## Why AWS Uses Multiple Subnets Across Two Availability Zones

In AWS, a subnet exists inside a single Availability Zone.

Because of that, building only one subnet per tier would create limitations later when the project introduces services that need or benefit from multi-AZ networking.

For Project 01, the AWS track will use two Availability Zones from the beginning.

Each Availability Zone will contain:

- One application subnet
- One data subnet
- One management subnet

This gives the environment six total subnets.

Later in the project, this design can support services such as:

- An Application Load Balancer across multiple Availability Zones
- Amazon RDS with a DB subnet group spanning multiple Availability Zones
- Application resources distributed across more than one Availability Zone

Planning for this now helps avoid redesigning the VPC and CIDR structure later.

---

## Planned Network Layout

Your Week 1 network should follow this general structure:

```text
VPC
│
├── Availability Zone A
│   ├── App-A          Public
│   ├── Data-A         Private
│   └── Management-A   Private
│
└── Availability Zone B
    ├── App-B          Public
    ├── Data-B         Private
    └── Management-B   Private
```

This gives you six total subnets.

The actual application, database, compute resources, and load balancer will be introduced in later weeks.

---

## Public vs Private Access

### Public Application Subnets

The application subnets should be public.

A public subnet has a route to the Internet Gateway.

For Week 1:

- App-A should have a route to the Internet Gateway
- App-B should have a route to the Internet Gateway

These subnets will later support application-facing resources such as Memos and potentially an Application Load Balancer.

A subnet being public does **not** automatically mean every resource inside it is exposed to the internet.

Public exposure also depends on factors such as:

- Public IP configuration
- Security Group rules
- The service being deployed
- Application architecture

### Private Data Subnets

The data subnets should remain private.

These subnets will later support the PostgreSQL database tier using **Amazon RDS for PostgreSQL**.

The database should not have direct public internet access.

The application tier should eventually communicate with the database privately.

### Private Management Subnets

The management subnets should also remain private.

These subnets are reserved for future administrative or management-related resources that may be introduced later in Project 01.

They should not have direct public internet routes during Week 1.

---

## Memos and PostgreSQL

Memos can use SQLite by default.

SQLite stores application data in a local database file that lives with the application.

For Project 01, we are instead planning to use **PostgreSQL as a separate database tier**.

In AWS, the planned database service is:

**Amazon RDS for PostgreSQL**

This gives the project a real application-to-database architecture and allows later weeks to cover:

- Private database connectivity
- Application-to-database networking
- Security Group rules
- PostgreSQL traffic
- Database credentials
- Secrets management
- Backups
- Monitoring
- Troubleshooting

Amazon RDS is **not deployed during Week 1**.

The private data subnets created this week prepare the environment for the future database tier.

---

## AWS Services

Week 1 will primarily involve:

- Amazon VPC
- Subnets
- Route Tables
- Internet Gateway
- Security Groups
- Resource Tags

Network ACLs may be explored if you have a specific reason to use them, but they are not required.

Do not add services simply because they are available.

Every resource should have a purpose.

---

## Internet Gateway

An Internet Gateway is required for the Week 1 AWS architecture because the application subnets are public.

The Internet Gateway should be attached to the VPC.

The route table associated with the public application subnets should include a default route similar to:

```text
0.0.0.0/0 -> Internet Gateway
```

The private data and management subnets should not use this route for direct internet access.

---

## NAT Gateway

**Do not deploy a NAT Gateway during Week 1.**

Nothing required during Week 1 needs outbound internet access from the private data or management subnets.

Adding a NAT Gateway now would introduce unnecessary cost without solving a current requirement.

The goal this week is only to build the network foundation.

When outbound connectivity becomes necessary later in Project 01, we will evaluate the correct solution based on the actual architecture.

That may include:

- NAT Gateway
- VPC Endpoints
- Service-specific private connectivity
- Other AWS-native networking options

For example, some AWS services can be accessed privately using VPC endpoints instead of sending traffic through a NAT Gateway.

Do not deploy a NAT Gateway simply because it is available.

If a later requirement actually needs one, it will be introduced at that time.

---

## CIDR Planning

You are responsible for choosing and documenting your own valid CIDR ranges.

Example only:

```text
VPC: 10.10.0.0/16

Availability Zone A
-------------------
App-A:         10.10.1.0/24
Data-A:        10.10.11.0/24
Management-A:  10.10.21.0/24

Availability Zone B
-------------------
App-B:         10.10.2.0/24
Data-B:        10.10.12.0/24
Management-B:  10.10.22.0/24
```

You do not have to use these exact ranges.

Your design should:

- Avoid overlapping CIDR ranges
- Leave room for future growth
- Clearly identify the purpose of each subnet
- Clearly identify which Availability Zone each subnet belongs to
- Keep the addressing plan easy to understand and expand later

---

## Routing

At minimum:

- App-A should have a route to the Internet Gateway
- App-B should have a route to the Internet Gateway
- Data-A should not have a direct internet route
- Data-B should not have a direct internet route
- Management-A should not have a direct internet route
- Management-B should not have a direct internet route

You should understand how route tables determine whether a subnet is public or private.

Do not add routes simply because they are available.

Be prepared to explain:

- Why the application subnets are public
- Why the data subnets are private
- Why the management subnets are private
- Why a NAT Gateway is not needed yet
- Which routes will matter later as the environment grows

---

## Network Security

Security Groups should be used to begin establishing network boundaries and thinking about future communication between tiers.

At minimum, think about:

- Which tiers should eventually communicate?
- Should the database accept traffic from anything other than the application tier?
- Should management resources communicate directly with the database?
- Which inbound traffic should be denied?
- Which resources actually need public access?
- Which resources need outbound internet access?
- What traffic will PostgreSQL eventually require?

Avoid broad allow-all rules unless there is a clear reason for them.

The goal is not to create a perfect production security model during Week 1.

The goal is to understand why the network is segmented and prepare it for the security controls introduced later.

---

## Cost Guardrails

Week 1 should cost little to nothing.

You should not need to deploy:

- NAT Gateway
- EC2 instances
- ECS services
- Application Load Balancer
- Amazon RDS
- AWS Network Firewall
- Other paid compute or managed services

during Week 1.

Always review AWS pricing before deploying anything beyond the requirements.

Do not leave unnecessary paid resources running.

---

## Infrastructure as Code

Terraform is encouraged but not required during Week 1.

If you are still learning AWS networking, you may build the environment through the AWS Console.

If you are comfortable with Terraform, you are encouraged to deploy the Week 1 infrastructure using Infrastructure as Code.

Terraform will become a larger part of Project 01 as the environment grows.

---

## Deliverables

By the end of Week 1, provide:

- [ ] Architecture diagram
- [ ] VPC CIDR range
- [ ] Complete subnet/CIDR plan
- [ ] Availability Zone assignments
- [ ] Evidence showing the deployed VPC
- [ ] Evidence showing all six required subnets
- [ ] Evidence showing the Internet Gateway
- [ ] Evidence showing route tables and routing
- [ ] Evidence showing Security Groups or other network security controls
- [ ] Resource naming convention
- [ ] Tags used
- [ ] Short explanation of why two Availability Zones are being used
- [ ] Short explanation of which subnets are public vs private
- [ ] Short explanation of why a NAT Gateway was not deployed
- [ ] Short explanation of your security decisions
- [ ] Any issue you encountered and how you approached or resolved it

---

## Acceptance Criteria

Week 1 is complete when:

- [ ] One VPC has been successfully deployed
- [ ] At least two Availability Zones are being used
- [ ] Two public application subnets exist across separate Availability Zones
- [ ] Two private data subnets exist across separate Availability Zones
- [ ] Two private management subnets exist across separate Availability Zones
- [ ] Every subnet has a documented CIDR range
- [ ] Subnet ranges do not overlap
- [ ] An Internet Gateway is attached to the VPC
- [ ] Public application subnet routing is configured appropriately
- [ ] Private data subnets do not have direct internet routes
- [ ] Private management subnets do not have direct internet routes
- [ ] No NAT Gateway has been deployed
- [ ] Network security controls are configured where appropriate
- [ ] Resources follow a consistent naming convention
- [ ] Project/environment tags are applied where supported
- [ ] An architecture diagram has been created
- [ ] You can explain the purpose of the major AWS resources you deployed

---

## Engineering Questions

Before deploying a resource, ask yourself:

- What problem does this resource solve?
- Why does this subnet exist?
- Why are we using two Availability Zones?
- Why are the application subnets public?
- Why are the data and management subnets private?
- Which tiers should eventually communicate?
- How will Memos fit into this architecture later?
- How will Memos privately connect to PostgreSQL?
- What traffic will PostgreSQL eventually require?
- Why are we not using a NAT Gateway yet?
- Does this resource actually need internet access?
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
- An Application Load Balancer
- Amazon RDS for PostgreSQL
- Private application-to-database connectivity
- Identity and access controls
- Monitoring and troubleshooting
- Terraform and automation

If outbound internet connectivity from private resources becomes necessary later, we will decide at that point whether a NAT Gateway, VPC endpoints, or another AWS networking option is appropriate.

Build Week 1 with the expectation that you will continue using and improving this environment.

- Public application resources
- Private database/backend resources
- Private management/administrative resources

The network created this week will continue to be used and expanded throughout Project 01.

This is not a disposable lab.

---

## Requirements

Your AWS environment must include:

- One VPC
- At least two Availability Zones
- Two public application subnets, one in each Availability Zone
- Two private data/backend subnets, one in each Availability Zone
- Two private management subnets, one in each Availability Zone
- One Internet Gateway
- Appropriate route tables and routing
- Network-level security controls
- A documented CIDR/IP addressing plan
- Consistent resource naming
- Project/environment tags
- A simple architecture diagram

Your subnet ranges must not overlap.


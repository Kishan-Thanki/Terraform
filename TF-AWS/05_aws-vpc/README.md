# AWS VPC Fundamentals 🌐

![AWS](https://img.shields.io/badge/AWS-VPC-orange?logo=amazonaws)
![Networking](https://img.shields.io/badge/Domain-Networking-blue)
![Level](https://img.shields.io/badge/Level-Foundational-green)

This document provides a **clear, structured overview** of core **Amazon Web Services (AWS) Virtual Private Cloud (VPC)** concepts.

It is designed as a **learning guide and quick reference** for understanding how **secure, isolated networks** are designed, configured, and operated in AWS.


## Table of Contents

1. [What is a VPC?](#what-is-a-vpc)
2. [Typical AWS VPC Architecture](#typical-aws-vpc-architecture)
3. [Subnets](#subnets)
4. [VPC CIDR Blocks](#vpc-cidr-blocks)
5. [CIDR Explained](#cidr-explained)
6. [Route Tables](#route-tables)
7. [Internet Gateway (IGW)](#internet-gateway-igw)
8. [Security Groups](#security-groups)
9. [Security Groups vs Network ACLs](#security-groups-vs-network-acls)
10. [Best Practices](#best-practices)
11. [Final Takeaway](#final-takeaway)
12. [References & Credits](#references--credits)

## What is a VPC?

A **Virtual Private Cloud (VPC)** is a **logically isolated virtual network** within the AWS Cloud where you can launch and manage resources securely.

![AWS VPC Diagram](https://miro.medium.com/1*c-zq45cEGGVvOCnFpPyKuA.png)

### Key Characteristics

- Full control over **IP addressing, subnets, routing, and security**
- **Region-scoped**, but spans multiple **Availability Zones (AZs)**
- **Isolated by default** from the public internet
- Acts as the **networking foundation** for AWS workloads

> 💡 Think of a VPC as your **own private data center network**, but fully managed and scalable by AWS.

Official Documentation:  
https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html

## Typical AWS VPC Architecture

A production-grade VPC commonly includes:

- Public subnets (internet-facing)
- Private subnets (isolated backend)
- Internet Gateway (IGW)
- NAT Gateway
- Load Balancer
- EC2 instances

### Why This Matters

This layered design enables:

- **Security isolation**
- **Scalability**
- **Fault tolerance**
- **Controlled internet exposure**

AWS Reference Architecture:  
https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html

## Subnets

A **subnet** is a segmented portion of a VPC that:

- Belongs to **exactly one Availability Zone**
- Uses a **subset of the VPC CIDR block**
- Helps organize and isolate workloads

### Public Subnets

- Have a route to an **Internet Gateway**
- Commonly host:
  - Load balancers
  - Bastion hosts
  - Public web servers

### Private Subnets

- No direct route to the internet
- Used for:
  - Databases
  - Application servers
  - Internal APIs

💡 Private subnets can still access the internet **outbound** via a **NAT Gateway**.

Subnets Documentation:  
https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html

## VPC CIDR Blocks

When creating a VPC, you define a **CIDR block** that determines the total IP address range.

### Example

```text
10.0.0.0/16
````

* Provides **65,536 total IP addresses**
* All subnets are derived from this range

### Subnet Examples

```text
10.0.1.0/24 → Public Subnet
10.0.2.0/24 → Private Subnet
```

Each `/24` subnet provides **256 IP addresses**.

CIDR Planning Guide:
[https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html#VPC_Sizing](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html#VPC_Sizing)

## CIDR Explained

### IPv4 Basics

* IPv4 addresses are **32 bits**
* Written in dotted-decimal format

### Binary Representation

```text
10.0.1.0
00001010.00000000.00000001.00000000
```

### What `/24` Means

* First **24 bits** → network portion
* Remaining **8 bits** → host addresses

### Address Range

```text
10.0.1.0   → Network address
10.0.1.255 → Broadcast address
```

### AWS Reserved IPs

AWS reserves:

* First **4 IPs**
* Last **1 IP**

Usable IPs per subnet ≈ **251**

AWS IP Reservation Rules:
[https://docs.aws.amazon.com/vpc/latest/userguide/subnet-sizing.html](https://docs.aws.amazon.com/vpc/latest/userguide/subnet-sizing.html)


## Route Tables

A **route table** controls how traffic flows **within the VPC and outside it**.

### Core Concepts

* Every subnet must be associated with **one route table**
* Routes are defined as **destination → target**

### Common Routes

| Destination | Target           |
| ----------- | ---------------- |
| VPC CIDR    | `local`          |
| `0.0.0.0/0` | Internet Gateway |
| `0.0.0.0/0` | NAT Gateway      |

> Route tables decide **where traffic goes**, not whether it’s allowed.

Routing Documentation:
[https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)

## Internet Gateway (IGW)

An **Internet Gateway** enables communication between a VPC and the public internet.

### Key Properties

* Horizontally scaled and highly available
* Attached **to the VPC**, not individual subnets
* Enables **bidirectional** traffic

### Requirements for Internet Access

1. IGW attached to the VPC
2. Route: `0.0.0.0/0 → IGW`
3. Public or Elastic IP on the resource
4. Security Group allows traffic

IGW Documentation:
[https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)

## Security Groups

**Security Groups** act as **stateful virtual firewalls** at the resource level.

### Characteristics

* Stateful (return traffic is automatically allowed)
* Controls inbound and outbound traffic
* Rules defined by:

  * Protocol
  * Port
  * Source / Destination

### Example Use Cases

* Allow HTTP (80) from ALB
* Allow SSH (22) only from Bastion Host

Security Groups Guide:
[https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)

## Security Groups vs Network ACLs

| Feature  | Security Group | Network ACL  |
| -------- | -------------- | ------------ |
| Scope    | Resource-level | Subnet-level |
| Stateful | ✅ Yes          | ❌ No         |
| Rules    | Allow only     | Allow + Deny |

> Most modern AWS architectures rely primarily on **Security Groups**.

NACL Documentation:
[https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html)

## Best Practices

* Use **private subnets** for sensitive workloads
* Spread workloads across **multiple AZs**
* Never expose databases to the internet
* Use NAT Gateway for private outbound access
* Plan CIDR ranges with future growth in mind

AWS Well-Architected Framework:
[https://aws.amazon.com/architecture/well-architected/](https://aws.amazon.com/architecture/well-architected/)

## Final Takeaway

> **A VPC is not just networking — it is the security, routing, and isolation foundation of everything you deploy in AWS.**


## References & Credits

### Official AWS Documentation

* Amazon VPC Overview
  [https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
* Subnets & CIDR
  [https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html)
* Route Tables
  [https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)
* Internet Gateway
  [https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)
* Security Groups
  [https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)

### Credits

* Diagrams and conceptual references based on **AWS Official Documentation**
* AWS®, Amazon VPC®, and related services are trademarks of **Amazon Web Services, Inc.**

**License**
Educational content for learning and reference purposes.
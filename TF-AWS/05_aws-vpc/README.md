# AWS VPC Fundamentals

This README provides a **clear, structured overview** of key **Amazon Web Services (AWS) Virtual Private Cloud (VPC)** concepts. It is designed as a **learning guide and quick reference** to understand how secure, isolated networks are built and operated in AWS.

---

## What is a VPC?

A **Virtual Private Cloud (VPC)** is a **logically isolated virtual network** within the AWS Cloud where you can launch and manage resources securely.

[!Ha](https://miro.medium.com/1*c-zq45cEGGVvOCnFpPyKuA.png)

### Key Characteristics

* Full control over **IP addressing, subnets, routing, and security**
* **Region-scoped**, but spans multiple **Availability Zones (AZs)**
* **Isolated by default** from the internet and other VPCs
* Foundation for deploying secure cloud architectures

Think of a VPC as your **own private data center network**, but fully managed by AWS.

---

## Typical AWS VPC Architecture

A production-ready VPC usually includes:

* Public subnets (internet-facing)
* Private subnets (isolated backend)
* Internet Gateway (IGW)
* NAT Gateway
* Load Balancer
* EC2 instances

This separation enforces **security, scalability, and fault tolerance**.

---

## Subnets

A **subnet** is a smaller, segmented portion of a VPC that:

* Belongs to **exactly one Availability Zone**
* Uses a **subset of the VPC CIDR range**
* Organizes and isolates resources

### Types of Subnets

#### Public Subnets

* Have a route to an **Internet Gateway**
* Used for:

  * Load Balancers
  * Bastion hosts
  * Public-facing web servers

#### Private Subnets

* No direct internet route
* Used for:

  * Databases
  * Backend services
  * Internal APIs

Private subnets can still **access the internet outbound** using a **NAT Gateway**.

---

## VPC CIDR Block

When creating a VPC, you define a **CIDR block** (Classless Inter-Domain Routing) that determines the total IP address range for the VPC.

### Example

```
10.0.0.0/16
```

* Provides **65,536 total IP addresses**
* Subnets are carved from this range

### Subnet Examples

```
10.0.1.0/24  → Public Subnet
10.0.2.0/24  → Private Subnet
```

Each `/24` subnet provides **256 IPs**.

---

## CIDR Explained: 10.0.1.0/24

### IPv4 Basics

* IPv4 addresses are **32 bits long**
* Written in dotted-decimal format

### Binary Representation

```
10.0.1.0
00001010.00000000.00000001.00000000
```

### What `/24` Means

* First **24 bits** → network portion
* Remaining **8 bits** → host addresses

### IP Range

```
10.0.1.0   → Network address
10.0.1.255 → Broadcast address
```

AWS reserves:

* First 4 IPs
* Last 1 IP

So usable IPs ≈ **251 per subnet**

---

## Route Tables

A **route table** defines how traffic is routed **within and outside** the VPC.

### Core Rules

* Every subnet must be associated with **one route table**
* Route tables contain **destination → target** mappings

### Common Routes

| Destination | Target                       |
| ----------- | ---------------------------- |
| VPC CIDR    | local                        |
| 0.0.0.0/0   | IGW (public subnet)          |
| 0.0.0.0/0   | NAT Gateway (private subnet) |

Route tables decide **where packets go**, not whether they are allowed (that’s security groups).

---

## Internet Gateway (IGW)

An **Internet Gateway** is a managed AWS component that enables communication between your VPC and the public internet.

### Key Properties

* Horizontally scaled and highly available
* Attached **to a VPC**, not a subnet
* Enables **bidirectional** internet traffic

### Requirements for Internet Access

1. IGW attached to VPC
2. Route table entry: `0.0.0.0/0 → IGW`
3. Public IP or Elastic IP on the resource
4. Security Group allows traffic

---

## Security Groups

**Security Groups** act as **virtual firewalls** at the resource level (EC2, ALB, etc.).

### Characteristics

* **Stateful** (return traffic is automatically allowed)
* Control inbound and outbound traffic
* Rules defined by:

  * Protocol
  * Port
  * Source / Destination

### Example

* Allow HTTP (80) from Load Balancer
* Allow SSH (22) from Bastion host

Security Groups are the **primary security mechanism** in AWS networking.

---

## Security Groups vs Network ACLs (Quick Note)

| Feature         | Security Group | Network ACL  |
| --------------- | -------------- | ------------ |
| Scope           | Resource-level | Subnet-level |
| Stateful        | Yes            | No           |
| Rule evaluation | Allow only     | Allow + Deny |

Most architectures rely primarily on **Security Groups**.

---

## Best Practices

* Use **private subnets** for sensitive workloads
* Spread subnets across **multiple AZs**
* Never expose databases directly to the internet
* Use NAT Gateways for private outbound access
* Keep CIDR ranges future-proof

---

## Final Takeaway

> A VPC is not just a network — it is the **security and routing foundation** of everything you deploy in AWS.

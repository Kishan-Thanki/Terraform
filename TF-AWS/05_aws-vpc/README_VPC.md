# AWS VPC with Public & Private Subnets (Terraform) 🌐

![AWS](https://img.shields.io/badge/AWS-VPC-orange?logo=amazonaws)
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple?logo=terraform)
![Level](https://img.shields.io/badge/Level-Foundational-green)

This project provisions a **basic AWS networking setup** using **Terraform**, including a **VPC**, **public and private subnets**, **internet connectivity**, and an **EC2 instance deployed in the public subnet**.

It is designed for **learning, sandbox testing, and building a strong foundation in AWS networking concepts** using Infrastructure as Code (IaC).

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [High-Level Network Flow](#high-level-network-flow)
3. [Resources Created](#resources-created)
4. [Key Concepts Demonstrated](#key-concepts-demonstrated)
5. [Important Notes](#important-notes)
6. [Real-World Production Usage](#real-world-production-usage)
7. [Final Insight](#final-insight)
8. [References & Credits](#references--credits)

## Architecture Overview

This Terraform configuration creates the following AWS resources:

- **Custom VPC** with a defined CIDR block
- **Public Subnet** (internet-facing)
- **Private Subnet** (isolated)
- **Internet Gateway (IGW)** attached to the VPC
- **Public Route Table** routing traffic to the IGW
- **EC2 instance** launched inside the public subnet

The goal is to clearly demonstrate **how traffic flows inside a VPC** and **why public and private subnets behave differently**.

## High-Level Network Flow

```text
            Internet
                |
          (0.0.0.0/0)
                |
        [ Internet Gateway ]
                |
        [ Public Route Table ]
                |
        [ Public Subnet ] ---- EC2 Instance
                |
        [ Private Subnet ]
        (No internet access)
````

### Key Observations

* Only the **public subnet** has a route to the Internet Gateway
* The **private subnet is isolated by design**
* Internet access is controlled purely by **routing**, not by subnet type

## Resources Created

### 3.1 Virtual Private Cloud (VPC)

```text
CIDR: 10.0.0.0/16
```

**Purpose:**

* Defines the **network boundary**
* Provides a private IP range for all resources
* Isolated from other VPCs by default

AWS Reference:
[https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)

### 3.2 Subnets

| Subnet Type    | CIDR Block    | Purpose                       |
| -------------- | ------------- | ----------------------------- |
| Public Subnet  | `10.0.2.0/24` | Internet-facing workloads     |
| Private Subnet | `10.0.1.0/24` | Internal / isolated workloads |

**Key Points:**

* Each subnet belongs to **one Availability Zone**
* Subnets are carved from the VPC CIDR block
* Isolation is achieved via **route tables**

AWS Reference:
[https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html)

### 3.3 Internet Gateway (IGW)

**Role:**

* Enables communication between the VPC and the public internet
* Required for inbound and outbound internet access

**Important:**

* IGW is attached to the **VPC**, not to individual subnets

AWS Reference:
[https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)

### 3.4 Route Tables

The **public route table** contains:

```text
0.0.0.0/0 → Internet Gateway
```

**Behavior:**

* Associated **only with the public subnet**
* Enables internet access for resources in that subnet
* Private subnet has **no default internet route**

AWS Reference:
[https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)

### 3.5 EC2 Instance

| Property        | Value          |
| --------------- | -------------- |
| AMI             | Amazon Linux 2 |
| Instance Type   | `t2.micro`     |
| Subnet          | Public Subnet  |
| Internet Access | Enabled        |

**Capabilities:**

* Can access the internet
* Can be accessed from the internet (subject to Security Groups)

AWS EC2 Reference:
[https://docs.aws.amazon.com/ec2/](https://docs.aws.amazon.com/ec2/)

## Key Concepts Demonstrated

This project reinforces several **fundamental AWS networking concepts**:

* VPC-level isolation
* CIDR block planning
* Public vs private subnet behavior
* Internet Gateway usage
* Route table associations
* EC2 placement within a subnet
* Infrastructure as Code with Terraform

## Important Notes

* The **private subnet has no internet access**
* EC2 is intentionally deployed in the **public subnet**
* Security Groups are **not explicitly defined** (AWS default is used)
* This setup is **for learning only**, not production-ready

## Real-World Production Usage

In real-world environments, this architecture is usually extended with:

* NAT Gateway (for private subnet outbound access)
* Application Load Balancer (ALB)
* Auto Scaling Groups
* Multiple Availability Zones
* Hardened Security Groups & Network ACLs
* IAM Roles for EC2
* Centralized logging & monitoring

AWS Well-Architected Framework:
[https://aws.amazon.com/architecture/well-architected/](https://aws.amazon.com/architecture/well-architected/)

## Final Insight

> **Understanding VPC fundamentals is the foundation of cloud engineering.**
> Once this architecture is clear, advanced AWS networking becomes intuitive.

## References & Credits

### Official AWS Documentation

* Amazon VPC Overview
  [https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
* Subnets
  [https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html)
* Route Tables
  [https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)
* Internet Gateway
  [https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)
* Amazon EC2
  [https://docs.aws.amazon.com/ec2/](https://docs.aws.amazon.com/ec2/)

### Terraform Documentation

* AWS Provider
  [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* Terraform Language
  [https://developer.hashicorp.com/terraform/language](https://developer.hashicorp.com/terraform/language)

### Credits

* Architecture concepts based on **AWS Official Documentation**
* Terraform examples aligned with **HashiCorp best practices**
* AWS®, Amazon VPC®, and EC2® are trademarks of **Amazon Web Services, Inc.**

**License**
This repository is intended for **educational and learning purposes**.
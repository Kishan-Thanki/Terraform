
# AWS VPC with Public & Private Subnets (Terraform)

This project provisions a **basic AWS networking setup** using **Terraform**, including a VPC, public and private subnets, internet connectivity, and an EC2 instance deployed in the public subnet.

The configuration is designed for **learning, sandbox testing, and foundational cloud networking understanding**.


## Architecture Overview

The infrastructure created by this Terraform code includes:

- **VPC** with custom CIDR range
- **Public Subnet** (internet-facing)
- **Private Subnet** (isolated)
- **Internet Gateway** attached to the VPC
- **Public Route Table** routing traffic to the Internet Gateway
- **EC2 instance** launched in the public subnet

### High-level diagram

```

       Internet
          |
     (0.0.0.0/0)
          |
 [ Internet Gateway ]
          |
          |
[ Public Route Table ]
          |
          |
   [ Public Subnet ] ---- EC2 Instance
          |
  [ Private Subnet ] (no internet access)

````

## Resources Created

### 1. VPC

```hcl
10.0.0.0/16
```

* Provides a private IP address range for all resources
* Acts as the network boundary

---

### 2. Subnets

| Subnet Type    | CIDR Block    | Purpose                       |
| -------------- | ------------- | ----------------------------- |
| Public Subnet  | `10.0.2.0/24` | Internet-facing resources     |
| Private Subnet | `10.0.1.0/24` | Internal / isolated resources |

* Each subnet resides within the same VPC
* Subnets are logically isolated

---

### 3. Internet Gateway

* Enables communication between the VPC and the internet
* Required for public subnet internet access

---

### 4. Route Table

Public Route Table contains:

```
0.0.0.0/0 → Internet Gateway
```

* Associated **only** with the public subnet
* Private subnet has no internet route

---

### 5. EC2 Instance

| Property      | Value                           |
| ------------- | ------------------------------- |
| AMI           | Amazon Linux 2                  |
| Instance Type | `t2.micro`                      |
| Subnet        | Public Subnet                   |
| Public Access | Enabled (via IGW & route table) |

This instance can:

* Access the internet
* Be accessed from the internet (if security groups allow)

---

## Key Concepts Demonstrated

* VPC isolation
* CIDR block planning
* Public vs Private subnet design
* Internet Gateway behavior
* Route table associations
* EC2 placement within a subnet

---

## Important Notes

* The **private subnet has no internet access**
* The EC2 instance is intentionally placed in the **public subnet**
* Security Groups are not explicitly defined here (AWS default is used)
* This setup is **not production-ready** — it is for learning and sandbox use

---

## Real-World Usage

In production environments, this setup is typically extended with:

* NAT Gateway for private subnet outbound access
* Application Load Balancer
* Auto Scaling Groups
* Multiple Availability Zones
* Security Groups and NACL hardening
* IAM roles for EC2

---

## Final Insight

> **Understanding VPC fundamentals is the foundation of cloud engineering.
> Once you understand this setup, everything else in AWS networking becomes easier.**
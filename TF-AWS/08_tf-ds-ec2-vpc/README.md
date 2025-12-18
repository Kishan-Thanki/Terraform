# Terraform: Using Data Sources to Launch an EC2 Instance in an Existing AWS Network

![AWS](https://img.shields.io/badge/AWS-VPC%20%7C%20EC2-orange?logo=amazonaws)
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple?logo=terraform)
![Status](https://img.shields.io/badge/Status-Learning%20Sandbox-green)

This document demonstrates how to use **Terraform Data Sources** to **discover and reuse existing AWS infrastructure**—such as a VPC, subnet, and security group—while provisioning a new **EC2 instance**.

Instead of recreating networking resources, Terraform **queries AWS for already-existing infrastructure** and safely builds on top of it.

This approach reflects **real-world cloud engineering workflows**, where shared networking is centrally managed and compute resources are provisioned independently.

## Table of Contents

- [What This Project Demonstrates](#what-this-project-demonstrates)
- [Architecture Overview](#architecture-overview)
- [Terraform File Structure](#terraform-file-structure)
- [EC2 Instance Resource](#ec2-instance-resource)
- [Data Sources Explained](#data-sources-explained)
  - [Fetch Existing VPC](#fetch-existing-vpc)
  - [Fetch Existing Security Group](#fetch-existing-security-group)
  - [Fetch Existing Private Subnet](#fetch-existing-private-subnet)
- [Why Use Data Sources?](#why-use-data-sources)
- [Important Notes & Best Practices](#important-notes--best-practices)
- [Final Insight](#final-insight)
- [Official References & Documentation](#official-references--documentation)
- [Credits](#credits)

## What This Project Demonstrates

- Using **Terraform data sources** to fetch existing AWS resources
- Launching an EC2 instance **inside an existing private subnet**
- Attaching an existing **security group**
- Clear separation between **resource creation** and **resource discovery**
- Writing Terraform that works safely in **shared AWS environments**


## Architecture Overview

**Region:** `ap-south-1`  
**VPC:** Existing (fetched via tags)  
**Subnet:** Existing private subnet  
**Security Group:** Existing security group  

### High-Level Flow

```

Terraform
|
|-- Query existing VPC
|-- Query existing Private Subnet
|-- Query existing Security Group
|
Create EC2 Instance
|
|-- Attached to Private Subnet
|-- Protected by Existing Security Group

````


## Terraform File Structure

```text
.
├── main.tf          # EC2 resource definition
├── data_source.tf  # Data sources for VPC, subnet, security group
└── README.md
````

## EC2 Instance Resource

```hcl
resource "aws_instance" "sandbox_ec2" {
  ami             = "ami-02b8269d5e85954ef"
  instance_type   = "t2.micro"
  subnet_id       = data.aws_subnet.private_subnet.id
  security_groups = [data.aws_security_group.sandbox_sg.id]

  tags = {
    Name = "sandbox-ec2"
  }
}
```

### Key Points

* EC2 is launched **inside an existing private subnet**
* No public IP is assigned (private subnet)
* Uses an **existing security group**
* No duplicate networking resources are created

Reference:
[https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)


## Data Sources Explained

### Fetch Existing VPC

```hcl
data "aws_vpc" "sandbox_vpc" {
  tags = {
    Name = "sandbox_vpc"
  }
}
```

**Why this matters:**

* Avoids hardcoding VPC IDs
* Works across multiple environments
* Safe for shared AWS accounts

Reference:
[https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc)


### Fetch Existing Security Group

```hcl
data "aws_security_group" "sandbox_sg" {
  tags = {
    Name = "sandbox-sg"
  }
}
```

**Why this matters:**

* Reuses centrally managed security rules
* Prevents security drift
* Common in enterprise AWS architectures

Reference:
[https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group)

### Fetch Existing Private Subnet

```hcl
data "aws_subnet" "private_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.sandbox_vpc.id]
  }

  tags = {
    Name = "private_subnet"
  }
}
```

**Why both filter and tags are used:**

* Ensures the subnet belongs to the correct VPC
* Prevents accidental cross-VPC selection
* Safer in large AWS environments

Reference:
[https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)

## Why Use Data Sources?

| Benefit        | Explanation                           |
| -------------- | ------------------------------------- |
| No duplication | Avoids recreating shared resources    |
| Safer          | Prevents accidental deletes           |
| Scalable       | Works across teams & environments     |
| Realistic      | Matches real production AWS workflows |

> **Terraform data sources allow you to build on reality, not assumptions.**

## Important Notes & Best Practices

* This EC2 instance will **not be publicly accessible**
* Internet access from a private subnet requires:

  * NAT Gateway (for outbound traffic)
  * Proper route table configuration
* Security Groups must already allow required traffic
* Tags must be **consistent and unique**

⚠️ **Note:**
`terraform destroy` removes **only the EC2 instance**, not the existing VPC, subnet, or security group.

## Final Insight

> **Terraform is most powerful when it adapts to existing infrastructure instead of fighting it.**
> Data sources are the bridge between **what already exists** and **what you want to build next**.

## Official References & Documentation

* Terraform Data Sources
  [https://developer.hashicorp.com/terraform/language/data-sources](https://developer.hashicorp.com/terraform/language/data-sources)

* AWS Provider Documentation
  [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

* AWS EC2 Documentation
  [https://docs.aws.amazon.com/ec2/](https://docs.aws.amazon.com/ec2/)

* AWS VPC Documentation
  [https://docs.aws.amazon.com/vpc/](https://docs.aws.amazon.com/vpc/)

## Credits

* **Terraform** by HashiCorp
* **Amazon Web Services (AWS)**
* Community examples and official documentation
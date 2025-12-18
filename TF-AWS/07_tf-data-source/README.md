# Terraform Data Sources with AWS

This document demonstrates how to use **Terraform data sources** to **fetch existing and dynamic information from AWS** and reuse it inside Terraform-managed infrastructure.

The focus is on understanding **read-only data access**, **real-world usage patterns**, and **how Terraform resolves dependencies automatically**.


## What Are Data Sources in Terraform?

In Terraform, a **data source** allows you to **query and read information** from:

* Existing cloud resources (created outside Terraform)
* Resources created earlier by Terraform
* AWS metadata and account details
* Dynamic platform information (regions, AZs, AMIs, identity, etc.)

> **Data sources do not create or modify infrastructure.**
> They only **read** information and expose it for use.


## Why Data Sources Matter (Real-World Context)

Data sources are essential because:

* Cloud environments are **dynamic**
* Hardcoding values leads to **fragile infrastructure**
* Teams often reuse **shared or pre-existing resources**
* Automation and CI/CD require **environment-aware configurations**

✔ Used heavily in **production Terraform codebases**


## Project Overview

### AWS & Terraform Configuration

* **Terraform Version:** 1.x
* **AWS Provider Version:** `6.26.0`
* **Region:** `ap-south-1`
* **AWS Profile:** `terraform-admin`

## File Structure

```
.
├── main.tf           # Provider & EC2 resource
├── data_source.tf    # All Terraform data sources
├── outputs.tf        # Outputs from data sources
└── README.md
```

## Provider Configuration (`main.tf`)

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "terraform-admin"
}
```

This configures:

* AWS provider
* Region selection
* Credential profile

## Using Data Sources in EC2 Resource

```hcl
resource "aws_instance" "sandbox_ec2" {
  ami           = data.aws_ami.name.id
  instance_type = "t2.micro"

  tags = {
    Name = "sandbox-ec2"
  }
}
```

### What’s Important Here?

* AMI ID is **not hardcoded**
* Terraform fetches the **latest valid AMI dynamically**
* Resource automatically depends on the data source

## Data Sources Explained (`data_source.tf`)

### 1️⃣ Fetch Latest Amazon Linux AMI

```hcl
data "aws_ami" "name" {
  most_recent = true
  owners      = ["amazon"]
}
```

✔ Dynamically fetches the **latest Amazon-owned AMI**

✔ Avoids outdated or deprecated AMIs

✔ Common production pattern

### 2️⃣ Fetch Existing Security Group by Tag

```hcl
data "aws_security_group" "name" {
  tags = {
    Name = "sandbox-sg"
  }
}
```

✔ Reads a **pre-existing Security Group**

✔ Useful when SG is managed separately

✔ Enables modular infrastructure

> ⚠️ The Security Group **must already exist**


### 3️⃣ Fetch Available Availability Zones

```hcl
data "aws_availability_zones" "names" {
  state = "available"
}
```

✔ Returns a list of AZs in the region

✔ Useful for:

* Subnet creation
* Auto Scaling
* Multi-AZ designs

### 4️⃣ Fetch AWS Caller Identity

```hcl
data "aws_caller_identity" "name" {}
```

Returns:

* AWS Account ID
* IAM User / Role ARN
* User ID

✔ Extremely useful for:

* Debugging credentials
* Multi-account setups
* Auditing

### 5️⃣ Fetch Current AWS Region

```hcl
data "aws_region" "name" {}
```

✔ Useful for dynamic region-based logic

✔ Avoids hardcoding region values


## Outputs (`outputs.tf`)

```hcl
output "aws_ami" {
  value = data.aws_ami.name.id
}

output "aws_security_group" {
  value = data.aws_security_group.name.id
}

output "aws_availability_zones" {
  value = data.aws_availability_zones.names
}

output "caller_info" {
  value = data.aws_caller_identity.name
}

output "aws_region" {
  value = data.aws_region.name
}
```

After `terraform apply`, Terraform prints:

* Selected AMI ID
* Security Group ID
* Available AZs
* AWS account identity
* Current region


## Dependency Graph (How Terraform Executes)

Terraform automatically determines order:

```
Data Sources
     ↓
EC2 Resource
     ↓
  Outputs
```

✔ No manual dependency definitions

✔ Terraform handles execution safely

## Best Practices Demonstrated

Avoid hardcoding cloud values

Prefer dynamic discovery

Reuse existing infrastructure

Keep Terraform state clean

Enable environment portability

## Common Mistakes to Avoid

Hardcoding AMI IDs

Assuming default Security Groups

Ignoring AWS region differences

Mixing data sources and resources incorrectly

## When to Use Data Sources vs Resources

| Scenario                          | Use         |
| --------------------------------- | ----------- |
| Need existing resource info       | Data Source |
| Need to create new infrastructure | Resource    |
| Fetch account metadata            | Data Source |
| Provision infrastructure          | Resource    |

## Official References & Documentation

* Terraform Data Sources
  [https://developer.hashicorp.com/terraform/language/data-sources](https://developer.hashicorp.com/terraform/language/data-sources)

* AWS Provider Documentation
  [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

* AWS AMI Data Source
  [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)

* AWS Security Group Data Source
  [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group)

* AWS Availability Zones
  [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)

## Credits

* **Terraform** by HashiCorp
* **Amazon Web Services (AWS)**
* Community best practices from real-world DevOps workflows

## Final Insight

> **Terraform becomes powerful not when you create resources,
> but when you learn how to read and adapt to the cloud dynamically.**

Data sources are what turn Terraform into **real infrastructure automation**, not just scripts.

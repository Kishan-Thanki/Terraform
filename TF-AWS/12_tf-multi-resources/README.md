# Terraform: Multi Resources

![Terraform](https://img.shields.io/badge/Terraform-IaC-purple?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20VPC-orange?logo=amazonaws)
![Status](https://img.shields.io/badge/Status-Learning%20%7C%20Sandbox-green)

This document demonstrates **multiple ways to provision EC2 instances using Terraform**, focusing on:

- **Complex variable types** (`list(object)` and `map(object)`)
- The difference between **`count` vs `for_each`**
- Dynamic resource creation
- Safe, scalable infrastructure patterns used in real-world projects

This project is designed as a **learning reference**, **mini-project**, and **Terraform playground**.

## Table of Contents

- [Project Overview](#project-overview)
- [What This Project Demonstrates](#what-this-project-demonstrates)
- [Architecture Overview](#architecture-overview)
- [Terraform File Structure](#terraform-file-structure)
- [Variable Design](#variable-design)

  - [List-Based Configuration](#list-based-configuration)
  - [Map-Based Configuration](#map-based-configuration)

- [EC2 Provisioning Strategies](#ec2-provisioning-strategies)

  - [Using count (List)](#using-count-list)
  - [Using for_each (Map)](#using-for_each-map)

- [Why for_each Is Preferred](#why-for_each-is-preferred)
- [How to Run](#how-to-run)
- [Best Practices](#best-practices)
- [Official References](#official-references)
- [Credits](#credits)
- [Final Insight](#final-insight)

## Project Overview

This Terraform project creates:

- A **custom VPC**
- Multiple **subnets**
- Multiple **EC2 instances**, driven by **input configuration**
- EC2 instances distributed across subnets

The EC2 instances are defined using **external configuration (`terraform.tfvars`)**, allowing easy scaling without modifying core Terraform code.

## What This Project Demonstrates

- Terraform **complex variable types**

- `list(object)` vs `map(object)`

- `count` vs `for_each`

- Dynamic subnet selection

- Clean tagging strategies

- Real-world Terraform patterns

## Architecture Overview

```
Terraform
│
├── Create VPC
├── Create Subnets (count-based)
│
└── Create EC2 Instances
     ├── Using count (list-based)
     └── Using for_each (map-based)
```

## Terraform File Structure

```text
.
├── main.tf            # VPC, Subnets, EC2 resources
├── variables.tf       # Input variable definitions
├── terraform.tfvars.  # EC2 configuration data
└── README.md
```

## Variable Design

### List-Based Configuration

```hcl
variable "ec2_config_list" {
  type = list(object({
    ami           = string
    instance_type = string
  }))
}
```

**terraform.tfvars**

```hcl
ec2_config_list = [
  {
    ami           = "ami-02b8269d5e85954ef"
    instance_type = "t2.micro"
  },
  {
    ami           = "ami-087d1c9a513324697"
    instance_type = "t2.micro"
  }
]
```

✔ Order-based

❌ Index-sensitive

❌ Renaming causes recreation

### Map-Based Configuration (Recommended)

```hcl
variable "ec2_config_map" {
  type = map(object({
    ami           = string
    instance_type = string
  }))
}
```

**terraform.tfvars**

```hcl
ec2_config_map = {
  "Ubuntu-24-04" = {
    ami           = "ami-02b8269d5e85954ef"
    instance_type = "t2.micro"
  },
  "Ubuntu-22-04" = {
    ami           = "ami-087d1c9a513324697"
    instance_type = "t2.micro"
  }
}
```

✔ Key-based identity

✔ Safe renaming

✔ Production-friendly

## EC2 Provisioning Strategies

### Using `count` (List)

```hcl
resource "aws_instance" "sandbox_ec2" {
  count         = length(var.ec2_config_list)
  ami           = var.ec2_config_list[count.index].ami
  instance_type = var.ec2_config_list[count.index].instance_type

  tags = {
    Name = "sandbox-ec2-${count.index}"
  }
}
```

⚠️ **Problem:**
Changing list order destroys and recreates instances.

### Using `for_each` (Map)

```hcl
resource "aws_instance" "sandbox_ec2" {
  for_each      = var.ec2_config_map
  ami           = each.value.ami
  instance_type = each.value.instance_type

  tags = {
    Name = "sandbox-ec2-${each.key}"
  }
}
```

✔ Stable

✔ Predictable

✔ Enterprise-safe

## Why for_each Is Preferred

| Feature         | count       | for_each  |
| --------------- | ----------- | --------- |
| Identity        | Index-based | Key-based |
| Rename safe     | ❌          | ✅        |
| Order sensitive | Yes         | No        |
| Production use  | ⚠️          | ✅        |

> **Use `count` for simple repetition.
> Use `for_each` for real infrastructure.**

## Best Practices

- Prefer **map + for_each** for EC2 and stateful resources
- Avoid index-based identity in production
- Keep configuration data outside `main.tf`
- Use meaningful keys (`Ubuntu-24-04`, `web-01`, `api-02`)
- Treat Terraform state as critical infrastructure data

## Final Insight

> **Lists scale infrastructure.
> Maps protect identity.
> for_each is how Terraform becomes production-ready.**

This repository represents **real-world Terraform thinking**, not just tutorials

## Official References

- Terraform `for_each`
  [https://developer.hashicorp.com/terraform/language/meta-arguments/for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

- Terraform `count`
  [https://developer.hashicorp.com/terraform/language/meta-arguments/count](https://developer.hashicorp.com/terraform/language/meta-arguments/count)

- Terraform Type Constraints
  [https://developer.hashicorp.com/terraform/language/expressions/type-constraints](https://developer.hashicorp.com/terraform/language/expressions/type-constraints)

- AWS EC2 Resource
  [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

## Credits

- **Terraform** by HashiCorp
- **Amazon Web Services (AWS)**
- Official Terraform Registry Documentation
- Community best practices

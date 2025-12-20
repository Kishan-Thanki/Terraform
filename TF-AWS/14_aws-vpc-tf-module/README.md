# Terraform AWS VPC Using Official Module (Sandbox) 🧱

![AWS](https://img.shields.io/badge/AWS-VPC-orange?logo=amazonaws)
![Terraform](https://img.shields.io/badge/Terraform-Modules-purple?logo=terraform)
![Status](https://img.shields.io/badge/Status-Learning%20Sandbox-green)

This folder demonstrates **building AWS networking using a Terraform module** instead of manually defining every resource.

The goal is to **understand Terraform Modules**, not just use them.

This is a deliberate shift from:

> *“How do I create a VPC?”*
> to
> *“How do professionals package and reuse infrastructure safely?”*

## Table of Contents

1. [What Are Terraform Modules?](#what-are-terraform-modules)
2. [Why Use Modules?](#why-use-modules)
3. [What This Configuration Does](#what-this-configuration-does)
4. [High-Level Network Layout](#high-level-network-layout)
5. [Important Observations](#important-observations)
6. [How to Run](#how-to-run)
7. [Key Takeaways](#key-takeaways)
8. [Why This Matters](#why-this-matters)
9. [References & Credits](#references--credits)

## What Are Terraform Modules?

**Terraform Modules** are containers for multiple resources that are used together.

A module consists of:

* A collection of `.tf` files
* Stored in a directory (local or remote)
* Exposed via input variables and outputs

Terraform itself treats **every directory as a module** — including the root directory.

Official definition (Terraform):

> Modules are the main way to package and reuse resource configurations with Terraform.

Terraform modules documentation:
[https://developer.hashicorp.com/terraform/language/modules](https://developer.hashicorp.com/terraform/language/modules)

## Why Use Modules?

Without modules:

* Networking code becomes verbose
* Best practices must be reimplemented every time
* Mistakes are easy to repeat

With modules:

* Complex infrastructure is **abstracted safely**
* Community-reviewed patterns are reused
* Teams standardize infrastructure design

This project uses the **official Terraform AWS VPC module**, maintained by HashiCorp & the community.

## What This Configuration Does

This sandbox configuration:

✔ Uses the **terraform-aws-modules/vpc/aws** module

✔ Creates a **custom VPC** (`10.0.0.0/16`)

✔ Automatically discovers **available AZs**

✔ Creates:

* 1 public subnet

* 1 private subnet

  ✔ Applies consistent naming & tagging

All low-level resources (route tables, IGW, subnet associations, etc.) are handled **internally by the module**.

## High-Level Network Layout

```text
              AWS Region (ap-south-1)
                       |
                  [ VPC 10.0.0.0/16 ]
                       |
        -------------------------------------
        |                                   |
[ Public Subnet ]                    [ Private Subnet ]
 10.0.1.0/24                           10.0.2.0/24
```

### Important Insight

> Even though you don’t see route tables, IGWs, or subnet associations,
> **they still exist** — the module creates and manages them for you.

This abstraction is the **core value of modules**.

## Important Observations

### Availability Zones Are Data-Driven

Instead of hardcoding AZs, this setup:

* Queries AWS for available AZs
* Automatically adapts to the region

This improves:

* Portability
* Reliability
* Future scalability

AWS AZ reference:
[https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)

### Module Version Pinning Matters

The VPC module version is explicitly pinned.

Why this matters:

* Prevents breaking changes
* Ensures reproducibility
* Critical for team environments

Terraform module versioning:
[https://developer.hashicorp.com/terraform/language/modules/sources#version](https://developer.hashicorp.com/terraform/language/modules/sources#version)

## Key Takeaways

* Modules are **abstractions**, not magic
* Real AWS resources still exist underneath
* Version pinning is mandatory
* Data sources make infrastructure adaptive
* Modules represent **production-grade Terraform usage**

## Why This Matters

In real-world environments:

* Nobody writes raw VPC code repeatedly
* Teams rely on **shared modules**
* Security and networking patterns are standardized

Understanding modules means understanding:

* How large Terraform codebases work
* How platform teams operate
* How infrastructure scales safely

> Beginners write resources.
> Professionals design modules.

## References & Credits

### Terraform Documentation

* Terraform Modules
  [https://developer.hashicorp.com/terraform/language/modules](https://developer.hashicorp.com/terraform/language/modules)
* Using Terraform Modules
  [https://developer.hashicorp.com/terraform/tutorials/modules/module](https://developer.hashicorp.com/terraform/tutorials/modules/module)
* Module Versioning
  [https://developer.hashicorp.com/terraform/language/modules/sources#version](https://developer.hashicorp.com/terraform/language/modules/sources#version)

### AWS Documentation

* Amazon VPC Overview
  [https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
* Availability Zones
  [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)

### Module Used

* terraform-aws-modules/vpc/aws
  [https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)

### Credits & Disclaimer

* AWS®, Amazon VPC® are trademarks of **Amazon Web Services, Inc.**
* Terraform® is a trademark of **HashiCorp**
* This project is for **learning and experimentation purposes**

**License**
MIT / Educational Use
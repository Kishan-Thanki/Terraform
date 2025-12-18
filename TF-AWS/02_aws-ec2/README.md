# Terraform: AWS EC2 Instance with Validation

![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-EC2-orange?logo=amazonaws)
![Status](https://img.shields.io/badge/Status-Learning%20Project-blue)
![License](https://img.shields.io/badge/License-Educational-green)

This repository demonstrates **how to provision, validate, manage, and destroy an AWS EC2 instance using Terraform** and **Infrastructure as Code (IaC)** principles.

It focuses on **correct Terraform workflow, configuration structure, state management, and validation**, aligned with **official HashiCorp and AWS documentation**.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Terraform Configuration](#terraform-configuration)
3. [Terraform Workflow Commands](#terraform-workflow-commands)
4. [Terraform Lifecycle](#terraform-lifecycle)
5. [Terraform Configuration Basics](#terraform-configuration-basics)
6. [State Management](#state-management)
7. [Variables](#terraform-variables)
8. [Outputs](#terraform-outputs)
9. [Project File Structure](#project-file-structure)
10. [How Terraform Uses These Files](#how-terraform-uses-these-files)
11. [Summary](#summary)
12. [References & Credits](#references--credits)


## Project Overview

This project demonstrates:

- **Infrastructure as Code (IaC)** using Terraform
- AWS **EC2 instance provisioning**
- Configuration validation
- Predictable infrastructure lifecycle
- State-based resource tracking

### AWS Region
- `ap-south-1` (Mumbai)  You can use what best suites you!

## Terraform Configuration

Terraform configuration defines **what infrastructure should exist**, not how to create it.

### Terraform Block

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}
````

#### Explanation

* Declares provider dependencies
* Locks provider version for consistency
* Ensures reproducible deployments

Official Reference:
[https://developer.hashicorp.com/terraform/language/providers/requirements](https://developer.hashicorp.com/terraform/language/providers/requirements)

### Provider Block

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

#### Explanation

* Configures AWS as the provider
* Sets deployment region
* Uses credentials from:

  * Environment variables
  * AWS CLI config
  * IAM Roles (**recommended for production**)

Official Reference:
[https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

### EC2 Resource Block

```hcl
resource "aws_instance" "sandbox_ec2" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t2.micro"

  tags = {
    Name = "sandbox-ec2"
  }
}
```

#### Explanation

* `aws_instance` → EC2 resource type
* `sandbox_ec2` → Terraform logical name
* `ami` → OS image
* `instance_type` → Compute capacity
* `tags` → Identification, billing, automation

AWS EC2 Docs:
[https://docs.aws.amazon.com/ec2/](https://docs.aws.amazon.com/ec2/)

## Terraform Workflow Commands

Terraform follows a **safe, predictable lifecycle**.

### 1️⃣ Initialize

```bash
terraform init
```

* Downloads providers
* Initializes backend
* Prepares working directory

Docs: [https://developer.hashicorp.com/terraform/cli/commands/init](https://developer.hashicorp.com/terraform/cli/commands/init)

### 2️⃣ Validate

```bash
terraform validate
```

* Validates syntax and configuration
* No AWS API calls
* Ensures error-free code

Docs: [https://developer.hashicorp.com/terraform/cli/commands/validate](https://developer.hashicorp.com/terraform/cli/commands/validate)

### 3️⃣ Plan

```bash
terraform plan
```

* Compares desired vs actual state
* Shows planned actions
* Prevents accidental changes

Docs: [https://developer.hashicorp.com/terraform/cli/commands/plan](https://developer.hashicorp.com/terraform/cli/commands/plan)

### 4️⃣ Apply

```bash
terraform apply
```

* Executes planned changes
* Requests confirmation

```bash
terraform apply -auto-approve
```

Docs: [https://developer.hashicorp.com/terraform/cli/commands/apply](https://developer.hashicorp.com/terraform/cli/commands/apply)

### 5️⃣ Destroy

```bash
terraform destroy
```

* Deletes all managed resources
* Used for cleanup and cost control

Docs: [https://developer.hashicorp.com/terraform/cli/commands/destroy](https://developer.hashicorp.com/terraform/cli/commands/destroy)

## Terraform Lifecycle

```text
Write Code → Validate → Plan → Apply → Manage State → Destroy
```

![Terraform_Workflow.svg](Terraform_Workflow.svg)

Workflow Guide:
[https://developer.hashicorp.com/terraform/tutorials/aws-get-started/infrastructure-as-code](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/infrastructure-as-code)

## Terraform Configuration Basics

* File extension: `.tf`
* Language: **HCL (HashiCorp Configuration Language)**
* Declarative syntax

Terraform also supports JSON, but **HCL is recommended**.

Language Docs:
[https://developer.hashicorp.com/terraform/language](https://developer.hashicorp.com/terraform/language)


## State Management

Terraform stores infrastructure state in:

```text
terraform.tfstate
```

### Purpose

* Maps Terraform resources to real AWS resources
* Tracks current infrastructure
* Enables efficient diffs

### Storage Options

| Type   | Use Case                   |
| ------ | -------------------------- |
| Local  | Learning & experimentation |
| Remote | Teams & production         |

Remote backends:

* S3 + DynamoDB
* Terraform Cloud

State Docs:
[https://developer.hashicorp.com/terraform/language/state](https://developer.hashicorp.com/terraform/language/state)

## Terraform Variables

```hcl
variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
}
```

Usage:

```hcl
provider "aws" {
  region = var.region
}
```

### Benefits

* No hardcoding
* Multi-environment support
* Reusable modules

Variables Docs:
[https://developer.hashicorp.com/terraform/language/values/variables](https://developer.hashicorp.com/terraform/language/values/variables)

## Terraform Outputs

```hcl
output "aws_instance_public_ip" {
  value = aws_instance.sandbox_ec2.public_ip
}
```

### Use Cases

* Display deployment results
* Pass values between modules
* CI/CD integration

Outputs Docs:
[https://developer.hashicorp.com/terraform/language/values/outputs](https://developer.hashicorp.com/terraform/language/values/outputs)

## Project File Structure

```text
.
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfstate        # ❌ DO NOT COMMIT
├── .terraform/              # ❌ DO NOT COMMIT
├── .terraform.lock.hcl      # ✅ COMMIT
```

## How Terraform Uses These Files

```text
main.tf            → Infrastructure definition
variables.tf       → Configurable inputs
outputs.tf         → Useful outputs
terraform.tfstate  → Real-world mapping
.lock.hcl          → Provider version locking
```

Terraform automatically:

* Loads all `.tf` files
* Builds dependency graph
* Applies minimal changes

## Summary

This project demonstrates:

* Terraform-based AWS EC2 provisioning
* Provider version locking
* Validation & planning
* Declarative infrastructure
* State-driven lifecycle management

## Final Cloud Engineering Insight

> **Terraform defines intent.**
> **State defines reality.**
> **Providers connect both.**

## References & Credits

### Official Documentation

* Terraform Docs: [https://developer.hashicorp.com/terraform](https://developer.hashicorp.com/terraform)
* AWS EC2 Docs: [https://docs.aws.amazon.com/ec2](https://docs.aws.amazon.com/ec2)
* Terraform AWS Provider:
  [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

### Learning Resources

* Terraform AWS Tutorials:
  [https://developer.hashicorp.com/terraform/tutorials/aws-get-started](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)
* AWS Well-Architected Framework:
  [https://aws.amazon.com/architecture/well-architected/](https://aws.amazon.com/architecture/well-architected/)

### License

Educational project.
All trademarks belong to:

* **HashiCorp**
* **Amazon Web Services**

# Terraform Overview

![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws)
![Status](https://img.shields.io/badge/Status-Learning%20Project-blue)
![License](https://img.shields.io/badge/License-Educational-green)

A **foundational and practical guide to Terraform**, designed to explain *what Terraform is*, *why it exists*, and *how it is used in real-world cloud engineering*.

This repository follows **official HashiCorp and AWS documentation**, focusing on **correct mental models**, not shortcuts.


##  Table of Contents

1. [What is Terraform?](#what-is-terraform)
2. [What is Infrastructure as Code (IaC)?](#what-is-infrastructure-as-code-iac)
3. [Problems Terraform Solves](#problems-terraform-solves)
4. [Why Terraform?](#why-terraform)
5. [Terraform Architecture](#terraform-architecture)
6. [Terraform Workflow](#terraform-workflow)
7. [Enterprise Usage & Best Practices](#enterprise-usage--best-practices)
8. [Production Repository Structure](#production-repository-structure)
9. [Key Takeaways](#key-takeaways)
10. [References & Credits](#references--credits)

## What is Terraform?

**Terraform** is an **open-source Infrastructure as Code (IaC)** tool developed by **HashiCorp**.

![terraform_workflow_1](terraform_workflow_1.png)

It allows you to **define, provision, update, and destroy infrastructure** using **declarative configuration files**, instead of manually creating resources through cloud consoles.

> 💡 **Core Idea:**  
> *Terraform lets you manage infrastructure the same way you manage application code.*

### Supported Platforms
- AWS
- Azure
- Google Cloud
- Kubernetes
- Hundreds of SaaS providers

### Terraform High-Level Workflow

```text
        Developer
            ↓
Terraform Configuration (.tf)
            ↓
      Terraform Core
            ↓
Provider (AWS / Azure / GCP)
            ↓
        Cloud APIs
````

### Official Documentation

* Terraform Main Docs: [https://developer.hashicorp.com/terraform](https://developer.hashicorp.com/terraform)
* What is Terraform?: [https://developer.hashicorp.com/terraform/intro](https://developer.hashicorp.com/terraform/intro)


## What is Infrastructure as Code (IaC)?

**Infrastructure as Code (IaC)** is the practice of managing infrastructure using **machine-readable configuration files** instead of manual steps.

### Without IaC

* Clicking in cloud consoles
* No audit trail
* Human error
* Environment drift

### With IaC

* Version-controlled infrastructure
* Repeatable deployments
* Predictable environments
* Easy rollback


### Manual vs IaC Comparison

```text
Manual Setup           Infrastructure as Code
------------           -----------------------
Human clicks           Declarative code
No history             Git history
Hard to rollback       Easy rollback
Inconsistent           Reproducible
```

### Official Reference

* IaC Use Cases (HashiCorp):
  [https://developer.hashicorp.com/terraform/intro/use-cases](https://developer.hashicorp.com/terraform/intro/use-cases)

## Problems Terraform Solves

### Traditional Infrastructure Issues

* Configuration drift
* No visibility
* Slow recovery
* Inconsistent environments

### Terraform Advantages

* Infrastructure as code
* Execution plans before changes
* Dependency-aware provisioning
* State-based drift detection

![terraform_workflow_2](terraform_workflow_2.png)

> **Intent (code) → Plan → Reality (cloud)**

## Why Terraform?

| Tool           | Scope           | Limitation             |
| -------------- | --------------- | ---------------------- |
| **Terraform**  | Multi-cloud IaC | Needs state management |
| CloudFormation | AWS only        | Vendor lock-in         |
| ARM / Bicep    | Azure only      | Vendor lock-in         |
| Pulumi         | Code-based IaC  | Higher learning curve  |
| Ansible        | Config mgmt     | Not infra provisioning |

Terraform excels at **provisioning infrastructure**, not configuring OS internals.

Official Comparison:
[https://developer.hashicorp.com/terraform/intro/vs](https://developer.hashicorp.com/terraform/intro/vs)

## Terraform Architecture

Terraform acts as a **translation engine** between your intent and cloud APIs.

### Core Components

* **Terraform Core**

  * Builds dependency graphs
  * Generates execution plans

* **Providers**

  * Translate Terraform syntax into API calls

* **State File**

  * Maps Terraform resources to real infrastructure
  * Detects drift


### Architecture Diagram

![terraform_workflow_3](terraform_workflow_3.svg)

```text
  Terraform Files
         ↓
  Terraform Core
         ↓
  Provider Plugin
         ↓
 Cloud Provider API
```

Official Docs:
[https://github.com/hashicorp/terraform/blob/main/docs/architecture.md](https://github.com/hashicorp/terraform/blob/main/docs/architecture.md)


## Terraform Workflow

Terraform follows a **safe and deterministic lifecycle**.

### Commands

```bash
terraform init     # Initialize providers & backend
terraform plan     # Preview changes
terraform apply    # Apply changes
terraform destroy  # Tear down infrastructure
```

### Lifecycle Flow

![terraform_workflow_4](terraform_workflow_4.svg)

```text
init → plan → apply → destroy
```

Official Reference:
[https://developer.hashicorp.com/terraform/cli/commands](https://developer.hashicorp.com/terraform/cli/commands)



## Enterprise Usage & Best Practices

### Real-World Use Cases

* Multi-environment parity (dev/stage/prod)
* Disaster recovery
* Ephemeral test environments
* Platform engineering
* Multi-account AWS setups


### Best Practices

#### 1️⃣ Remote State (Mandatory)

Never store `terraform.tfstate` locally in teams.

Use:

* S3 + DynamoDB (locking)
* Terraform Cloud

[https://developer.hashicorp.com/terraform/cloud-docs](https://developer.hashicorp.com/terraform/cloud-docs)


#### 2️⃣ Modular Design

* Avoid large monolithic files
* Build reusable modules

[https://developer.hashicorp.com/terraform/language/modules](https://developer.hashicorp.com/terraform/language/modules)


#### 3️⃣ CI/CD Integration

Terraform should run in pipelines, not manually in prod.

```text
Commit → Plan → Review → Apply
```

[https://developer.hashicorp.com/terraform/tutorials/automation](https://developer.hashicorp.com/terraform/tutorials/automation)

#### 4️⃣ Secrets Management

Never hardcode secrets.

Use:

* Environment variables
* AWS Secrets Manager
* HashiCorp Vault

[https://developer.hashicorp.com/vault](https://developer.hashicorp.com/vault)

## Production Repository Structure

```text
terraform-project/
├── modules/
│   ├── networking/
│   ├── compute/
│   └── database/
│
├── environments/
│   ├── dev/
│   └── prod/
│
├── README.md
├── .gitignore
└── pipeline.yaml
``` 

Official Structure Guide:
[https://developer.hashicorp.com/terraform/language/modules/develop/structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)


## Key Takeaways

* Terraform is **declarative**, not imperative
* AWS networking is **route-based**
* State is Terraform’s source of truth
* Infrastructure should be **auditable and reproducible**

> **Terraform doesn’t replace the cloud console — it replaces the risk of using it.**

## References & Credits

### Official Documentation

* HashiCorp Terraform: [https://developer.hashicorp.com/terraform](https://developer.hashicorp.com/terraform)
* AWS Documentation: [https://docs.aws.amazon.com](https://docs.aws.amazon.com)
* AWS Well-Architected Framework:
  [https://aws.amazon.com/architecture/well-architected/](https://aws.amazon.com/architecture/well-architected/)

### License

This repository is intended for **educational purposes**.

All trademarks and services belong to their respective owners:

* HashiCorp
* Amazon Web Services

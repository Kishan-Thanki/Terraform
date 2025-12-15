# Terraform Overview

## What is Terraform?

**Terraform** is an **open-source Infrastructure as Code (IaC)** tool developed by HashiCorp.  
It allows you to define, provision, and manage infrastructure using declarative configuration files instead of manual processes.


## What is Infrastructure as Code (IaC)?

**Infrastructure as Code (IaC)** enables you to manage and provision infrastructure through configuration files rather than using a graphical user interface (GUI).

IaC allows you to:
- Build infrastructure in a **safe, consistent, and repeatable** way
- **Version-control** infrastructure configurations
- **Reuse and share** infrastructure definitions
- Easily **modify and scale** infrastructure


## Terraform Workflow

![Terraform Workflow](terraform_flow_1.png)

![Terraform Workflow](terraform_flow_2.png)


## Terraform Lifecycle

### 1. Scope
Identify the infrastructure requirements for your project.

### 2. Author
Write configuration files to define your infrastructure resources.

### 3. Initialize
Install the required Terraform providers and initialize the working directory.

### 4. Plan
Preview the changes Terraform will make to your infrastructure before applying them.

### 5. Apply
Create or modify infrastructure resources based on the execution plan.


## Key Features of Terraform

- **Multiple Cloud Platforms**  
  Works with AWS, Azure, GCP, and many other providers.

- **Configuration for Humans**  
  Uses a simple, declarative language (HCL) that is easy to read and write.

- **Track Resources with State**  
  Maintains a state file to track real-world infrastructure.

- **Collaborate with Terraform Cloud**  
  Enables team collaboration, remote state management, and policy enforcement.

---

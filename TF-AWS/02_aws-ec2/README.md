# Terraform: AWS EC2 Instance with Validation

This document explains **how Terraform is used to provision, validate, manage, and destroy an AWS EC2 instance** using **Infrastructure as Code (IaC)**.  

It also covers **Terraform configuration concepts, workflow commands, lifecycle, state management, variables, outputs, and project file structure**.


## 1. Terraform Configuration

The following Terraform configuration defines:
- The required AWS provider
- The AWS region
- An EC2 instance resource

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

#### Terraform Block Explanation

* Specifies the **provider dependency**
* Locks the AWS provider to a specific version for consistency
* Ensures reproducible infrastructure across environments

---

### Provider Block

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

#### Provider Block Explanation

* Configures how Terraform communicates with AWS
* Sets the region to **ap-south-1 (Mumbai)**
* Uses credentials from:

  * Environment variables
  * AWS CLI configuration
  * IAM roles (recommended in production)

---

### Resource Block (EC2 Instance)

```hcl
resource "aws_instance" "sandbox_ec2" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t2.micro"

  tags = {
    Name = "sandbox-ec2"
  }
}
```

#### Resource Block Explanation

* `aws_instance` → EC2 resource type
* `sandbox_ec2` → Logical Terraform resource name
* `ami` → Defines the operating system image
* `instance_type` → Specifies compute capacity
* `tags` → Helps with identification, billing, and automation

## 2. Terraform Workflow Commands

Terraform follows a predictable lifecycle to manage infrastructure safely.



### 1️⃣ Initialize Terraform

```bash
terraform init
```

**Purpose:**

* Downloads required providers
* Initializes the working directory
* Prepares Terraform for execution



### 2️⃣ Validate Configuration

```bash
terraform validate
```

**Purpose:**

* Verifies syntax and configuration correctness
* Ensures Terraform files are **error-free**
* Does **not** communicate with AWS



### 3️⃣ Preview Changes

```bash
terraform plan
```

**Purpose:**

* Compares desired state (code) with current state (AWS)
* Displays planned actions:

  * Create
  * Update
  * Destroy
* Helps avoid unintended infrastructure changes



### 4️⃣ Apply Changes

```bash
terraform apply
```

**Purpose:**

* Executes the planned changes
* Creates or updates infrastructure
* Requests user confirmation before execution

#### Apply Outcomes

* **Create** → New resources are provisioned
* **Update** → Existing resources are modified
* **Destroy** → Resources are removed if no longer defined

```bash
terraform apply -auto-approve
```

*Skips the manual approval prompt*



### 5️⃣ Destroy Resources

```bash
terraform destroy
```

**Purpose:**

* Deletes all resources managed by Terraform
* Used for cleanup and cost control

```bash
terraform destroy -auto-approve
```

## 3. Terraform Lifecycle Workflow

![Terraform\_Workflow](Terraform_Workflow.svg)

This workflow demonstrates the **full lifecycle management** of an AWS EC2 instance using Terraform, including **validation for error-free configuration**.

## 4. Terraform Configuration Basics

### Terraform Configuration Files

* File extension: `.tf`
* Format: **HCL (HashiCorp Configuration Language)**
* Language type: **Declarative**

  * You define *what* you want, not *how* to create it

Terraform also supports **JSON format**, though HCL is recommended for readability.

## 5. State Management

When you run `terraform apply`, Terraform creates a **state file**:

```text
terraform.tfstate
```

### Purpose of the State File

* Maintains a mapping between Terraform resources and real cloud resources
* Tracks current infrastructure state
* Enables Terraform to calculate changes efficiently

### State Storage Options

* **Local**: Stored on the developer’s machine
* **Remote**: Stored in shared backends (S3, Terraform Cloud, etc.)

Remote state enables:

* Team collaboration
* State locking
* Safer multi-user workflows

## 6. Terraform Variables

Variables make configurations **flexible and reusable**.

```hcl
# variables.tf
variable "region" {
  description = "The AWS region to create resources in"
  default     = "ap-south-1"
}
```

Usage in `main.tf`:

```hcl
provider "aws" {
  region = var.region
}
```

### Benefits

* Avoids hardcoding values
* Enables multi-environment deployments (dev, staging, prod)

Values can be overridden using:

* `terraform.tfvars`
* CLI flags
* Environment variables

## 7. Terraform Outputs

Outputs expose useful information after deployment.

```hcl
# outputs.tf
output "aws_instance_public_ip" {
  value = aws_instance.sandbox_ec2.public_ip
}
```

### Use Cases

* Display EC2 public IP after creation
* Pass values to other Terraform modules
* Integrate with CI/CD pipelines


## 8. Terraform Project File & Directory Structure Explained

When working with Terraform, several files and directories are created automatically or manually to manage infrastructure efficiently.

---

### `.terraform/` Directory

**Purpose:**

* Created automatically after running `terraform init`
* Stores **provider plugins** and internal Terraform data

**Key Points:**

* Contains downloaded provider binaries (e.g., AWS provider)
* Environment-specific
* **Should NOT be committed to Git**

---

### `.terraform.lock.hcl`

**Purpose:**

* Locks the exact provider versions used in the project

**Key Points:**

* Automatically generated
* Ensures all team members use the **same provider versions**
* Improves consistency and reproducibility
* **Should be committed to Git**

Similar to `package-lock.json`, `poetry.lock`, or `go.sum`.

---

### `terraform.tfstate`

**Purpose:**

* Maintains the **current state of your infrastructure**

**Key Points:**

* Maps Terraform resources to real AWS resources
* Stores metadata such as:

  * Resource IDs
  * Dependencies
  * Attributes (IP addresses, ARNs, etc.)
* Used during `plan` and `apply`

⚠️ **Sensitive file — should NOT be committed to Git**

---

### `terraform.tfstate.backup`

**Purpose:**

* Automatic backup of the previous state file

**Key Points:**

* Created before every successful `terraform apply`
* Used for recovery
* Acts as a rollback checkpoint

---

### `main.tf`

**Purpose:**

* Primary Terraform configuration file

**Contains:**

* Provider configuration
* Resource definitions
* Core infrastructure logic

Terraform automatically loads **all `.tf` files**, filenames do not affect execution order.

---

### `variables.tf`

**Purpose:**

* Centralized input variable definitions
* Improves flexibility and reuse

---

### `outputs.tf`

**Purpose:**

* Defines values Terraform displays after execution
* Enables integration and automation

## 9. How Terraform Uses These Files Together

```text
main.tf                 → Defines infrastructure
variables.tf            → Supplies configurable inputs
outputs.tf              → Exposes useful results
terraform.tfstate       → Tracks real-world state
.terraform/             → Stores providers & internal data
.terraform.lock.hcl     → Locks provider versions
```

Terraform automatically:

* Loads all `.tf` files
* Builds a dependency graph
* Compares desired state vs actual state
* Applies only required changes


## 10. Summary

This Terraform example demonstrates:

* Infrastructure as Code using AWS and Terraform
* Provider version control and regional configuration
* Validation, planning, applying, and destroying resources
* Declarative infrastructure definitions
* State management for tracking resources
* Use of variables and outputs for flexibility and automation

## Final Cloud Engineering Perspective

> **Terraform code defines intent.**
> **State files define reality.**
> **Providers bridge the gap between them.**

This structure enables:

* Safe automation
* Team collaboration
* Auditable infrastructure changes
* Production-grade cloud management
# Terraform AWS Remote Backend (S3) + EC2 🧱

![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-S3%20%7C%20EC2-orange?logo=amazonaws)
![State](https://img.shields.io/badge/State-Remote-blue)
![Level](https://img.shields.io/badge/Level-Intermediate-green)

This project demonstrates **provisioning an AWS EC2 instance using Terraform while storing Terraform state remotely in Amazon S3**.

It focuses on **real-world backend configuration**, **credential handling**, **state management**, and **common issues faced by engineers** when moving from local state to remote state.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Why Remote State Matters](#why-remote-state-matters)
3. [Architecture Overview](#architecture-overview)
4. [AWS Resources Managed](#aws-resources-managed)
5. [Terraform Configuration](#terraform-configuration)
6. [Backend Initialization & Issues](#backend-initialization--issues)
7. [Resource Lifecycle](#resource-lifecycle)
8. [Real-World Learnings](#real-world-learnings)
9. [Best Practices](#best-practices)
10. [References & Credits](#references--credits)

## Project Overview

**Terraform Remote Backend** enables teams to:

- Store Terraform state **centrally**
- Enable **collaboration**
- Prevent **state corruption**
- Improve **auditability and safety**

### Project Details

| Item | Value |
|----|----|
| Terraform Version | 1.x |
| AWS Provider | v6.26.0 |
| Backend | Amazon S3 |
| AWS Profile | `terraform-admin` |
| Purpose | Learn remote state + EC2 provisioning |

## Why Remote State Matters

### Local State Problems

- ❌ State stored on one developer’s laptop
- ❌ No locking → race conditions
- ❌ Accidental overwrites
- ❌ No audit trail

### Remote State Benefits

- ✅ Shared source of truth
- ✅ Persistent state
- ✅ Safe collaboration
- ✅ Enables CI/CD pipelines

> **Remote state is mandatory in production Terraform workflows.**

Official Docs:  
https://developer.hashicorp.com/terraform/language/state/remote

## Architecture Overview

### High-Level Flow

```text
Local Terraform Code
        │
        ▼
Terraform Core
        │
        ▼
Amazon S3 (Remote Backend)
        │
        ▼
AWS APIs
        │
        ▼
EC2 Instance
````

### Explanation

1. Terraform configuration exists locally
2. Terraform stores `terraform.tfstate` in S3
3. Terraform communicates with AWS APIs
4. EC2 instance is created and tracked via remote state

## AWS Resources Managed

### 1. S3 Backend Bucket

* Bucket Name: `your_s3_bucket_id`
* Purpose: Store Terraform state
* Created in a previous project (`03-aws-s3`)
* **Must exist before `terraform init`**

⚠️ **Never delete a backend bucket without migrating state**


### 2. EC2 Instance

| Property      | Value                                |
| ------------- | ------------------------------------ |
| AMI           | Amazon Linux / Ubuntu (region-based) |
| Instance Type | `t2.micro`                           |
| Tag           | `Name = sandbox-ec2`                 |

## Terraform Configuration

### Backend Configuration (`main.tf`)

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }

  backend "s3" {
    bucket = "your_s3_bucket_id"
    key    = "backend.tfstate"
    region = "region"
  }
}
```

### Provider Configuration

```hcl
provider "aws" {
  region  = var.region
  profile = "terraform-admin"
}
```

⚠️ **Important:**
Terraform backend authentication happens **before** provider authentication.

Backend Docs:
[https://developer.hashicorp.com/terraform/language/settings/backends/s3](https://developer.hashicorp.com/terraform/language/settings/backends/s3)

### EC2 Resource Definition

```hcl
resource "aws_instance" "sandbox_ec2" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t2.micro"

  tags = {
    Name = "sandbox-ec2"
  }
}
```

## Backend Initialization & Issues

### Terraform Initialization

```bash
terraform init
```

### Issue: No Valid Credential Sources

```text
Error: No valid credential sources found
```

#### Root Cause

* Terraform backend uses **AWS credentials independently**
* Provider credentials are **not yet active**
* AWS profile was not exported

### Solution

```bash
export AWS_PROFILE=terraform-admin
terraform init
```

✔ Backend successfully accesses S3

✔ State file created remotely

AWS Credential Resolution Order:
[https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

## Resource Lifecycle

### Create EC2 Instance

```bash
terraform apply
```

✔ EC2 instance created

✔ State stored in S3

### Destroy EC2 Instance

```bash
terraform destroy
```

### Issue: Bucket Not Empty

```text
BucketNotEmpty: The bucket you tried to delete is not empty
```

#### Explanation

* Terraform state file exists in backend bucket
* AWS blocks deletion of non-empty buckets

#### Solution Options

* Manually empty the bucket
* OR use `aws_s3_object` to manage objects
* OR migrate backend before deletion

AWS S3 Deletion Rules:
[https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-bucket.html](https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-bucket.html)

## Real-World Learnings

### 1. Terraform Backend Credentials

* Backend uses credentials **before provider**
* Expired tokens cause `terraform init` failures
* Always re-export profile after inactivity

```bash
export AWS_PROFILE=terraform-admin
```

### 2. Terraform State Drift

* Manual AWS changes ≠ Terraform state updates
* Causes Terraform to misjudge reality
* Use:

```bash
terraform refresh
terraform import
```

State Management Docs:
[https://developer.hashicorp.com/terraform/language/state](https://developer.hashicorp.com/terraform/language/state)

### 3. S3 Backend Safety

* One backend bucket can serve multiple projects
* Never delete without migrating state
* Enable versioning in production

### 4. Sandbox Cost Control

* Use small instance types
* Destroy resources after testing
* Avoid long-running sandboxes

## Best Practices

✔ Always use remote state in teams

✔ Separate backend from application resources

✔ Enable S3 versioning & encryption (production)

✔ Use IAM roles over access keys

✔ Never hardcode credentials

✔ Automate Terraform via CI/CD

## Final Insight

> **Terraform code defines intent.**
> **Remote state preserves reality.**
> **Backends make Terraform production-safe.**

## References & Credits

### Official Terraform Documentation

* Terraform Backends:
  [https://developer.hashicorp.com/terraform/language/settings/backends](https://developer.hashicorp.com/terraform/language/settings/backends)
* S3 Backend:
  [https://developer.hashicorp.com/terraform/language/settings/backends/s3](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
* Terraform State:
  [https://developer.hashicorp.com/terraform/language/state](https://developer.hashicorp.com/terraform/language/state)

### AWS Documentation

* Amazon EC2:
  [https://docs.aws.amazon.com/ec2/](https://docs.aws.amazon.com/ec2/)
* Amazon S3:
  [https://docs.aws.amazon.com/s3/](https://docs.aws.amazon.com/s3/)
* AWS IAM & Credentials:
  [https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials.html)

### Cloud Engineering Standards

* AWS Well-Architected Framework:
  [https://aws.amazon.com/architecture/well-architected/](https://aws.amazon.com/architecture/well-architected/)

### License

Educational and learning-focused content.
All product names and services belong to:

* **Amazon Web Services (AWS)**
* **HashiCorp**
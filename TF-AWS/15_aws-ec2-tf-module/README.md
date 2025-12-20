# Terraform AWS VPC + EC2 Using Modules (Sandbox) 🧩

![AWS](https://img.shields.io/badge/AWS-VPC%20%7C%20EC2-orange?logo=amazonaws)
![Terraform](https://img.shields.io/badge/Terraform-Modules-purple?logo=terraform)
![Status](https://img.shields.io/badge/Status-Learning%20Sandbox-green)

This document demonstrates provisioning **AWS networking and compute infrastructure using Terraform modules**, rather than defining every AWS resource manually.

The focus of this sandbox is to understand:

* How **Terraform modules abstract complexity**
* How **AWS VPC and EC2 actually interact**
* What **permissions Terraform really needs**
* How to debug **real-world infrastructure errors**

This project intentionally favors **clarity over abstraction layers**.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [High-Level Infrastructure Flow](#high-level-infrastructure-flow)
3. [Repository Structure](#repository-structure)
4. [What This Project Does](#what-this-project-does)
5. [Issues Faced & Lessons Learned](#issues-faced--lessons-learned)
6. [Security & IAM Considerations](#security--iam-considerations)
7. [How to Run](#how-to-run)
8. [Key Takeaways](#key-takeaways)
9. [Why This Matters](#why-this-matters)
10. [References & Credits](#references--credits)

## Architecture Overview

**AWS Region:** `ap-south-1 (Mumbai)`

### AWS Resources Managed

* Custom **VPC** (`10.0.0.0/16`)
* **Public Subnet** (`10.0.1.0/24`)
* **Private Subnet** (`10.0.2.0/24`)
* **Internet Gateway & Route Tables** (via module)
* **EC2 Instance**
* **Default Security Group**
* **Terraform Modules (VPC & EC2)**

All low-level networking components are **created internally by the modules**.

## High-Level Infrastructure Flow

```text
           AWS Region (ap-south-1)
                    |
              [ Custom VPC ]
              10.0.0.0/16
                    |
        --------------------------------
        |                              |
[ Public Subnet ]               [ Private Subnet ]
 10.0.1.0/24                     10.0.2.0/24
        |
   EC2 Instance
```

### Important Insight

> Even when you don’t explicitly define route tables, IGWs, or associations,
> **they still exist** — Terraform modules manage them internally.

## Repository Structure

```text
.
├── network.tf     # VPC module and AZ discovery
├── instance.tf    # EC2 instance module
└── README.md      # Documentation
```

Terraform automatically loads all `.tf` files and builds a dependency graph.

Terraform reference:
[https://developer.hashicorp.com/terraform/language/files](https://developer.hashicorp.com/terraform/language/files)

## What This Project Does

✔ Uses **official Terraform AWS modules**

✔ Creates a **custom VPC** without default VPC dependency

✔ Dynamically fetches **available Availability Zones**

✔ Launches an **EC2 instance in a public subnet**

✔ Uses **module outputs** instead of hardcoded values

✔ Demonstrates **realistic IAM permission requirements**

This project avoids:

* Custom modules
* Over-optimization
* Production hardening

The goal is **learning how things really work**.

## Issues Faced & Lessons Learned

This section documents **real errors encountered** and the **core AWS/Terraform concepts behind them**.

### 1️⃣ Missing SSM Permissions (AMI Resolution)

#### Symptom

Terraform failed while creating EC2 due to `ssm:GetParameter` access denied.

#### Root Cause

* EC2 Terraform module internally reads **AWS-managed SSM parameters**
* IAM user lacked SSM read permissions

#### Lesson

> Terraform modules may require **permissions you didn’t explicitly configure**.

AWS reference:
[https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters.html](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters.html)

### 2️⃣ “Why Is My EC2 Not Reachable?”

#### Common Causes

* Instance launched in **private subnet**
* No Internet Gateway
* No public IP
* Security group missing inbound rules

#### Lesson

> A subnet is not public by name — it is public by **routing**.

AWS VPC reference:
[https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)

### 3️⃣ Availability Zone Confusion

#### Issue

* Instance type not supported in a specific AZ
* Or AZ mismatch between subnet and instance

#### Lesson

> Availability Zones matter — and not all instance types exist everywhere.

AWS AZ reference:
[https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)

### 4️⃣ Security Group Assumptions

#### Mistake

Assuming the default security group automatically allows inbound traffic.

#### Reality

* Default SG allows **no inbound traffic**
* Explicit rules are required

#### Lesson

> Security Groups are **deny-by-default**.

AWS SG reference:
[https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)

### 5️⃣ Module ≠ Magic

#### Expectation

Modules “just work” without understanding internals.

#### Reality

* Modules still create real AWS resources
* IAM, networking, routing rules still apply

#### Lesson

> Modules abstract complexity, not responsibility.

## Security & IAM Considerations

⚠ This project is for **learning purposes**, not production.

Important notes:

* Terraform users require **SSM read-only access**
* Avoid `AdministratorAccess`
* Prefer IAM **groups** over user-level policies
* Use IAM **roles** for applications (not users)
* Rotate credentials regularly

AWS IAM best practices:
[https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)

## How to Run

```bash
terraform init
terraform plan
terraform apply
```

Cleanup:

```bash
terraform destroy
```

Terraform CLI reference:
[https://developer.hashicorp.com/terraform/cli](https://developer.hashicorp.com/terraform/cli)

## Key Takeaways

* Terraform modules are **production patterns**
* IAM permissions must match module internals
* Networking issues are usually **routing issues**
* AWS infrastructure is explicit, not automatic
* Errors are learning signals, not failures

## Why This Matters

In real environments:

* Teams rely heavily on Terraform modules
* IAM mistakes cause most outages
* Networking issues are the hardest to debug
* Understanding *why* something fails matters more than fixing it quickly

> Cloud skills aren’t built by copying examples —
> they’re built by breaking infrastructure and understanding why.

## References & Credits

### Terraform Documentation

* Terraform Modules
  [https://developer.hashicorp.com/terraform/language/modules](https://developer.hashicorp.com/terraform/language/modules)
* Using Terraform Modules
  [https://developer.hashicorp.com/terraform/tutorials/modules/module](https://developer.hashicorp.com/terraform/tutorials/modules/module)
* AWS Provider
  [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

### AWS Documentation

* Amazon VPC Overview
  [https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
* Amazon EC2 User Guide
  [https://docs.aws.amazon.com/ec2/](https://docs.aws.amazon.com/ec2/)
* Security Groups
  [https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)
* Systems Manager Parameter Store
  [https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html)

### Terraform Modules Used

* terraform-aws-modules/vpc/aws
  [https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
* terraform-aws-modules/ec2-instance/aws
  [https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)

### Credits & Disclaimer

* AWS®, Amazon EC2®, Amazon VPC® are trademarks of **Amazon Web Services, Inc.**
* Terraform® is a trademark of **HashiCorp**
* This project is intended for **educational and learning purposes**

**License**
MIT / Educational Use

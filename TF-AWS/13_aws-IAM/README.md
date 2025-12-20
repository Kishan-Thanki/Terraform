# Terraform AWS IAM Users via YAML (Sandbox) 🔐

![AWS](https://img.shields.io/badge/AWS-IAM-orange?logo=amazonaws)
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple?logo=terraform)
![Status](https://img.shields.io/badge/Status-Learning%20Sandbox-green)

This document demonstrates **automated AWS IAM user provisioning using Terraform**, driven entirely by a **YAML configuration file**.

The project focuses on **identity and access management fundamentals**, showing how to move from **manual IAM clicks** to a **repeatable, auditable Infrastructure-as-Code workflow**.

The goal is not abstraction — it is **understanding how IAM really behaves** when automated.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [High-Level Flow](#high-level-flow)
3. [Repository Structure](#repository-structure)
4. [What This Project Does](#what-this-project-does)
5. [Problems Faced & Lessons Learned](#problems-faced--lessons-learned)
6. [Security Considerations](#security-considerations)
7. [How to Run](#how-to-run)
8. [Key Takeaways](#key-takeaways)
9. [Why This Matters](#why-this-matters)
10. [References & Credits](#references--credits)

## Architecture Overview

**AWS Service:** IAM (Global)
**Region Used by Terraform:** `ap-south-1` (for provider authentication only)

### AWS Resources Managed

* IAM Users
* AWS Managed Policy Attachments
* IAM Console Login Profiles (password-based)
* Terraform Outputs (user list)

> IAM itself is a **global service**, but Terraform still requires a region for API calls.

## High-Level Flow

```text
users.yaml
   ↓
Terraform reads & decodes YAML
   ↓
IAM users are created
   ↓
AWS-managed policies are attached
   ↓
Console login passwords are generated
```

### Important Insight

> IAM permissions should be **data-driven**, not hardcoded.
>
> Moving identities to YAML makes access changes **reviewable, versioned, and predictable**.

## Repository Structure

```text
.
├── main.tf        # Terraform logic (IAM users, policies, login profiles)
├── users.yaml     # IAM users & permissions (source of truth)
└── README.md      # Project documentation
```

Terraform automatically loads all `.tf` files and builds a dependency graph.

Terraform reference:
[https://developer.hashicorp.com/terraform/language/files](https://developer.hashicorp.com/terraform/language/files)

## What This Project Does

✔ Creates IAM users from a YAML file

✔ Attaches **AWS-managed policies** per user

✔ Supports **multiple policies per user**

✔ Generates **console login passwords**

✔ Avoids hardcoding identities in Terraform

✔ Enables easy user lifecycle management

This project intentionally avoids:

* IAM Groups
* Custom policies
* Secret storage abstractions

…to keep the **core IAM behavior visible and understandable**.

## Problems Faced & Lessons Learned

This section documents **real IAM pitfalls** encountered while building automation.

### IAM Is Global (But Terraform Isn’t)

#### Confusion

* IAM resources are global
* Terraform still requires a region

#### Insight

The region is only used for:

* Authentication
* API endpoint resolution

AWS IAM reference:
[https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)

### Passwords Are Not Meant to Be Visible

#### Expectation

Terraform would output generated passwords.

#### Reality

* Terraform **intentionally suppresses sensitive values**
* Password exposure is considered insecure

#### Lesson

Passwords must be:

* Delivered securely
* Rotated regularly
* Stored outside Terraform state

AWS IAM Login Profiles:
[https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords.html)

### Policies ≠ Permissions You Should Always Grant

#### Mistake

Using broad managed policies for convenience.

#### Lesson

AWS-managed policies are:

* Useful for learning
* Often too permissive for production

Least privilege should be enforced via:

* IAM Groups
* Custom policies
* Roles (preferred for workloads)

AWS IAM best practices:
[https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)

## Security Considerations

⚠ This project is **educational** and not production-hardened.

Important notes:

* Do not commit credentials or passwords
* Avoid long-lived IAM users for applications
* Prefer IAM Roles for EC2, ECS, Lambda
* Rotate passwords and access keys regularly
* Use AWS Secrets Manager or Vault for secrets

## Key Takeaways

* IAM automation must be **data-driven**
* YAML makes access changes reviewable
* Terraform enforces consistency
* Passwords should never be treated casually
* IAM users are for humans — roles are for systems

## Why This Matters

IAM is the **first and most critical layer of cloud security**.

Most real-world cloud incidents are caused by:

* Over-permissive IAM
* Manual access changes
* Forgotten credentials

This project demonstrates how **small automation choices** can significantly improve:

* Security posture
* Auditability
* Operational discipline

> Infrastructure fails loudly.
> IAM fails silently — until it’s too late.

## References & Credits

### Official AWS Documentation

* AWS IAM Overview
  [https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
* IAM Users
  [https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html)
* AWS Managed Policies
  [https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html)
* IAM Best Practices
  [https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)

### Terraform Documentation

* AWS Provider
  [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* yamldecode Function
  [https://developer.hashicorp.com/terraform/language/functions/yamldecode](https://developer.hashicorp.com/terraform/language/functions/yamldecode)
* for_each Meta-Argument
  [https://developer.hashicorp.com/terraform/language/meta-arguments/for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

### Credits & Disclaimer

* AWS®, IAM® are trademarks of **Amazon Web Services, Inc.**
* Terraform® is a trademark of **HashiCorp**
* This project is intended for **learning and experimentation**

**License**
MIT / Educational Use
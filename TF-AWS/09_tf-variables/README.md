# Terraform Variables & Variable Precedence

![Terraform](https://img.shields.io/badge/Terraform-Variables%20%7C%20IaC-purple?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-EC2-orange?logo=amazonaws)
![Status](https://img.shields.io/badge/Status-Learning%20Sandbox-green)

This document explains **how Terraform variables work**, **different ways to pass variable values**, and **how Terraform decides which value wins** when multiple sources are used.

Understanding variable precedence is **critical for real-world Terraform usage**, especially across **DEV / PROD environments**, CI/CD pipelines, and shared infrastructure.

## Table of Contents

* [What Are Terraform Variables?](#what-are-terraform-variables)
* [Variable Definition (`variables.tf`)](#variable-definition-variablestf)
* [Ways to Provide Variable Values](#ways-to-provide-variable-values)

  * [1. `terraform.tfvars`](#1-terraformtfvars)
  * [2. `*.auto.tfvars`](#2-autotfvars)
  * [3. CLI Flags (`-var`, `-var-file`)](#3-cli-flags--var--var-file)
  * [4. Environment Variables (`TF_VAR_`)](#4-environment-variables-tf_var_)
* [Variable Precedence (Priority Order)](#variable-precedence-priority-order)
* [Project Structure](#project-structure)
* [Example: DEV vs PROD Configuration](#example-dev-vs-prod-configuration)
* [Best Practices](#best-practices)
* [Final Insight](#final-insight)
* [Official References](#official-references)
* [Credits](#credits)


## What Are Terraform Variables?

Terraform variables allow you to:

* Parameterize infrastructure
* Reuse the same code across environments
* Avoid hardcoding values
* Safely manage configuration differences (DEV, QA, PROD)

Variables are **declared once** and **overridden dynamically**.

## Variable Definition (`variables.tf`)

✔ Strong typing

✔ Validation rules

✔ Safe defaults

✔ Production-grade

## Ways to Provide Variable Values

Terraform supports **multiple input mechanisms**.

### 1. `terraform.tfvars`

Automatically loaded by Terraform.

```hcl
aws_instance_type = "t2.micro"

root_block_config = {
  size = 30
  type = "gp3"
}

ec2_instance_tags = {
  Name = "sandbox-ec2"
}
```

✔ Simple

✔ Common for local development


### 2. `*.auto.tfvars`

Automatically loaded **without specifying flags**.

Example: `prod.auto.tfvars`

```hcl
root_block_config = {
  size = 40
  type = "gp3"
}
```

✔ Ideal for environment-specific overrides

✔ Very common in real projects

### 3. CLI Flags (`-var`, `-var-file`)

```bash
terraform apply \
  -var="aws_instance_type=t3.micro" \
  -var-file="prod.auto.tfvars"
```

✔ Highest control

✔ Common in CI/CD pipelines

### 4. Environment Variables (`TF_VAR_`)

```bash
export TF_VAR_aws_instance_type=t3.micro
terraform apply
```

✔ Secure (no files committed)

✔ Widely used in automation

## Variable Precedence (Priority Order)

Terraform resolves variables in the following order
(**highest wins**):

1. `-var` (CLI flag)
2. `-var-file` (CLI file)
3. `*.auto.tfvars`
4. `terraform.tfvars`
5. Environment variables (`TF_VAR_*`)
6. Variable defaults

📌 **Important:**
Defaults are only used **if no other value is provided**.

## Project Structure

```text
.
├── main.tf
├── variables.tf
├── terraform.tfvars
├── prod.auto.tfvars
└── README.md
```

## Example: DEV vs PROD Configuration

| Environment | Source             | Root Volume |
| ----------- | ------------------ | ----------- |
| DEV         | `terraform.tfvars` | 30 GB gp3   |
| PROD        | `prod.auto.tfvars` | 40 GB gp3   |

Same Terraform code.
Different behavior.
**Zero duplication.**

## Best Practices

* Always define variables in `variables.tf`
* Use validation to prevent bad inputs
* Prefer `*.auto.tfvars` for environments
* Use `TF_VAR_*` in CI/CD
* Never hardcode environment values
* Do not commit secrets to `.tfvars`

## Official References

* Terraform Variables
  [https://developer.hashicorp.com/terraform/language/values/variables](https://developer.hashicorp.com/terraform/language/values/variables)

* Variable Definition Files
  [https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)

* Environment Variables
  [https://developer.hashicorp.com/terraform/cli/config/environment-variables](https://developer.hashicorp.com/terraform/cli/config/environment-variables)

* AWS EC2 Documentation
  [https://docs.aws.amazon.com/ec2/](https://docs.aws.amazon.com/ec2/)

## Credits

* **Terraform** by HashiCorp
* **Amazon Web Services (AWS)**
* Official Terraform documentation and community best practices

## Final Insight

> **Terraform variables are not just inputs —
> they are the foundation of reusable, environment-aware infrastructure.**

Once you understand **variable precedence**, Terraform stops being confusing and starts being **powerful**.

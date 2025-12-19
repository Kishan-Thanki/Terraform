# Terraform Expressions, Collections & Transformations

![Terraform](https://img.shields.io/badge/Terraform-HCL%20Expressions-purple?logo=terraform)
![Status](https://img.shields.io/badge/Status-Learning%20Sandbox-green)
![IaC](https://img.shields.io/badge/Infrastructure-as-Code-blue)

This document demonstrates **Terraform language fundamentals** related to:

* Variables and data types
* Lists, maps, and objects
* Local values (`locals`)
* `for` expressions
* Conditional filtering
* Collection transformations
* Outputs for inspection

The goal is to **deeply understand Terraform's expression language**, which is the foundation for writing clean, scalable, and production-grade Infrastructure as Code.


## Table of Contents

* [Why This Exists](#why-this-exists)
* [What This Demonstrates](#what-this-demonstrates)
* [Terraform Configuration Overview](#terraform-configuration-overview)
* [Variables Explained](#variables-explained)

  * [List of Numbers](#list-of-numbers)
  * [List of Objects](#list-of-objects)
  * [Map Variable](#map-variable)
* [Local Values & Expressions](#local-values--expressions)

  * [Simple Calculations](#simple-calculations)
  * [List Transformations](#list-transformations)
  * [Filtering with Conditions](#filtering-with-conditions)
  * [Object Field Extraction](#object-field-extraction)
  * [Map Transformations](#map-transformations)
* [Outputs](#outputs)
* [How to Run](#how-to-run)
* [Why This Matters in Real Projects](#why-this-matters-in-real-projects)
* [Official References](#official-references)
* [Credits](#credits)


## Why This Exists

Most Terraform tutorials focus on **providers and resources**, but real-world Terraform heavily relies on:

* Expressions
* Data transformations
* Dynamic values
* Collection handling

This example isolates those concepts so you can **learn Terraform logic without AWS noise**.

> If you understand this file, you can understand **90% of real Terraform codebases**.

## What This Demonstrates

✔ Terraform variable types

✔ Lists, maps, and objects

✔ `for` expressions

✔ Conditional filtering (`if`)

✔ Local values (`locals`)

✔ Map and list transformations

✔ Clean, readable outputs

## Terraform Configuration Overview

```hcl
terraform {}
```

This configuration does **not create infrastructure**.
It exists solely to demonstrate Terraform language features.

## Variables Explained

### List of Numbers

```hcl
variable "number_list" {
  type    = list(number)
  default = [1, 2, 3, 4, 5]
}
```

Used for:

* Mathematical operations
* Filtering
* Iteration examples

### List of Objects

```hcl
variable "person_list" {
  type = list(object({
    fname = string
    lname = string
  }))
}
```

Represents structured data — **very common in modules**, especially for:

* Users
* Instances
* Subnets
* Rules

### Map Variable

```hcl
variable "person_map" {
  type = map(number)
}
```

Maps are heavily used in Terraform for:

* Tags
* Lookups
* Configuration matrices

## Local Values & Expressions

### Simple Calculations

```hcl
locals {
  mul = 2 * 2
  add = 5 + 5
  neq = 2 != 3
}
```

Terraform supports:

* Arithmetic
* Boolean logic
* Comparisons

### List Transformations

```hcl
double_numbers = [for num in var.number_list : num * 2]
```

Result:

```text
[2, 4, 6, 8, 10]
```

Equivalent to a `map()` function in other languages.

### Filtering with Conditions

```hcl
odd_numbers = [for num in var.number_list : num if num % 2 != 0]
```

Result:

```text
[1, 3, 5]
```

This pattern is **extremely common** in production Terraform.

### Object Field Extraction

```hcl
first_names = [for person in var.person_list : person.fname]
```

Result:

```text
["John", "Paul"]
```

Used when extracting:

* Names
* IDs
* Attributes from complex structures


### Map Transformations

```hcl
map_keys = [for key, value in var.person_map : key]
```

```hcl
map_key_values = [for key, value in var.person_map : [key, value]]
```

```hcl
doubled_map = { for key, value in var.person_map : key => value * 2 }
```

Result:

```text
{
  one   = 2
  two   = 4
  three = 6
}
```

This pattern powers:

* Tag manipulation
* Dynamic blocks
* Policy generation

## Outputs

```hcl
output "map_keys" {
  value = local.map_keys
}
```

Outputs allow you to:

* Inspect computed values
* Debug expressions
* Validate logic before creating infrastructure

## How to Run

```bash
terraform init
terraform apply
```

Terraform will **not create any resources** — only evaluate expressions and show outputs.

## Why This Matters in Real Projects

Terraform expressions are used everywhere:

* Generating security rules
* Building dynamic blocks
* Creating tags
* Selecting subnets, AZs, IDs
* Adapting modules across environments

> **Terraform is declarative — but its expression language is functional.**

Understanding this unlocks **clean, reusable, production-grade IaC**.

## Final Insight

> **Resources build infrastructure.
> Expressions build intelligence.**

Mastering Terraform expressions is what separates **tutorial users** from **real Infrastructure Engineers** 

## Official References

* Terraform Expressions
  [https://developer.hashicorp.com/terraform/language/expressions](https://developer.hashicorp.com/terraform/language/expressions)

* Terraform `for` Expressions
  [https://developer.hashicorp.com/terraform/language/expressions/for](https://developer.hashicorp.com/terraform/language/expressions/for)

* Terraform Local Values
  [https://developer.hashicorp.com/terraform/language/values/locals](https://developer.hashicorp.com/terraform/language/values/locals)

* Terraform Variable Types
  [https://developer.hashicorp.com/terraform/language/expressions/type-constraints](https://developer.hashicorp.com/terraform/language/expressions/type-constraints)

## Credits

* **Terraform** by HashiCorp
* Official HashiCorp documentation
* Community best practices
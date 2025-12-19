# Terraform Built-in Functions: Strings, Numbers & Collections

![Terraform](https://img.shields.io/badge/Terraform-Language%20Functions-purple?logo=terraform)
![Status](https://img.shields.io/badge/Status-Learning%20Sandbox-green)
![IaC](https://img.shields.io/badge/IaC-Infrastructure%20as%20Code-blue)

This document demonstrates **Terraform built-in functions** using a **minimal, provider-less configuration**.
It focuses on **string manipulation, numeric operations, and collection transformations**, which are foundational concepts for writing clean, expressive Terraform code.

This project is intended for:

* Learning Terraform language fundamentals
* Understanding expressions, locals, variables, and outputs
* Practicing Terraform functions **without needing any cloud provider**

##  What This Example Covers

* Terraform **string functions**
* Terraform **numeric functions**
* Terraform **collection functions**
* Converting **lists to sets**
* Using `locals`, `variables`, and `outputs`
* Safe experimentation in a **sandbox setup**

## Project Structure

```text
.
├── main.tf
└── README.md
```

No providers, no cloud resources — **pure Terraform language learning**.

## Terraform Configuration

### `main.tf`

```hcl
terraform {}

locals {
  value = "Hello, World!"
}

variable "string_list" {
  type    = list(string)
  default = ["Server-1", "Server-2", "Server-3"]
}

output "output" {
  # String functions
  # value = lower(local.value)
  # value = upper(local.value)
  # value = startswith(local.value, "Hello")
  # value = startswith(local.value, "hello")
  # value = split(" ", local.value)

  # Numeric functions
  # value = max(1, 2, 3, 4, 5)
  # value = min(1, 2, 3, 4, 5)
  # value = abs(-15)

  # Collection functions
  # value = length(var.string_list)
  # value = join(":", var.string_list)
  # value = contains(var.string_list, "Server-2")

  # Convert list → set
  value = toset(var.string_list)
}
```

## Functions Explained

### String Functions

| Function       | Description                          |
| -------------- | ------------------------------------ |
| `lower()`      | Converts string to lowercase         |
| `upper()`      | Converts string to uppercase         |
| `startswith()` | Checks prefix match (case-sensitive) |
| `split()`      | Splits a string into a list          |

Example:

```hcl
lower("Hello") → "hello"
```

### Numeric Functions

| Function | Description                |
| -------- | -------------------------- |
| `max()`  | Returns the maximum value  |
| `min()`  | Returns the minimum value  |
| `abs()`  | Absolute value of a number |

Example:

```hcl
abs(-15) → 15
```

### Collection Functions

| Function     | Description                                   |
| ------------ | --------------------------------------------- |
| `length()`   | Number of elements in a collection            |
| `join()`     | Joins list elements into a string             |
| `contains()` | Checks if a value exists in a list            |
| `toset()`    | Converts a list to a set (removes duplicates) |

Example:

```hcl
toset(["a", "b", "a"]) → {"a", "b"}
```

⚠️ **Important:** Sets are unordered and remove duplicates.

## 🧠 Key Learnings

* Terraform is not just for infrastructure — it has a **rich expression language**
* Functions allow **data shaping before resource creation**
* `locals` help reduce duplication and improve readability
* Collections (`list`, `set`, `map`) behave differently — choose carefully

## Final Insight

> **Strong Terraform skills come from mastering the language itself — not just providers.**
> Understanding functions and expressions makes your infrastructure code cleaner, safer, and more powerful.

## Official References

* Terraform Built-in Functions
  [https://developer.hashicorp.com/terraform/language/functions](https://developer.hashicorp.com/terraform/language/functions)

* Terraform Expressions
  [https://developer.hashicorp.com/terraform/language/expressions](https://developer.hashicorp.com/terraform/language/expressions)

* Terraform Types & Values
  [https://developer.hashicorp.com/terraform/language/expressions/types](https://developer.hashicorp.com/terraform/language/expressions/types)

* Terraform Output Values
  [https://developer.hashicorp.com/terraform/language/values/outputs](https://developer.hashicorp.com/terraform/language/values/outputs)

## Credits

* **Terraform** by HashiCorp
* Official HashiCorp documentation
* Terraform community examples
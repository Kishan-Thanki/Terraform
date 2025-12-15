# Terraform Example: AWS EC2 Instance with Validation

## Terraform Configuration

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "sandbox_ec2" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t2.micro"

  tags = {
    Name = "sandbox-ec2"
  }
}
````

---

## Terraform Workflow Commands

### 1. Initialize Terraform

```bash
terraform init
```

* Installs required providers (AWS in this case)
* Prepares the working directory for Terraform operations

---

### 2. Validate Configuration

```bash
terraform validate
```

* Checks the configuration syntax
* Ensures Terraform files are **valid and error-free**
* Does not interact with cloud providers

---

### 3. Preview Changes

```bash
terraform plan
```

* Shows what Terraform **will create, update, or delete**
* Confirms actions before applying

---

### 4. Apply Changes

```bash
terraform apply
```

* Applies changes to create or update infrastructure
* Prompts for confirmation before making changes

**Apply outcomes:**

* **Create**: New resources are provisioned
* **Update**: Existing resources are modified
* **Destroy**: Resources are removed if configuration changes or deleted

> Optionally, skip the prompt with `-auto-approve`:

```bash
terraform apply -auto-approve
```

---

### 5. Destroy Resources

```bash
terraform destroy
```

* Deletes all resources created by Terraform
* Prompts for confirmation before destruction

> Optionally, skip the prompt with `-auto-approve`:

```bash
terraform destroy -auto-approve
```

---

This workflow demonstrates the **full lifecycle** of managing an AWS EC2 instance using Terraform, including **validation** for error-free configuration.

# Terraform Lifecycle Workflow

![Terraform_Workflow](Terraform_Workflow.svg)

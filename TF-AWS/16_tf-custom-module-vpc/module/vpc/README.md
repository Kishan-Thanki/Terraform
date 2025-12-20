# Terraform AWS VPC Module

> **This README is intentionally not narrow** and covers real-world usage.

A reusable, production-ready Terraform module for provisioning an AWS VPC with
public and private subnets, Internet Gateway, and public route tables.

This module is designed following **Terraform Registry best practices** and is
suitable for sandbox, dev, staging, and production environments.

## Features

- Creates an AWS VPC with a configurable CIDR block
- Supports multiple subnets using `for_each`
- Automatic classification of **public** and **private** subnets
- Conditionally creates:
  - Internet Gateway
  - Public Route Table
  - Route Table Associations
- Strong input validation for CIDR blocks and Availability Zones
- Clean outputs for downstream modules (EC2, EKS, RDS, ALB, etc.)

## Usage

### Basic Example

```hcl
module "vpc" {
  source = "./module/vpc"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "sandbox-vpc"
  }

  subnet_config = {
    public_subnet = {
      cidr_block = "10.0.1.0/24"
      az         = "ap-south-1a"
      name       = "public-subnet"
      public     = true
    }

    private_subnet = {
      cidr_block = "10.0.2.0/24"
      az         = "ap-south-1a"
      name       = "private-subnet"
      public     = false
    }
  }
}
````

## Inputs

| Name            | Description               | Type        | Required |
| --------------- | ------------------------- | ----------- | -------- |
| `vpc_config`    | VPC CIDR block and name   | object      | Yes      |
| `subnet_config` | Map of subnet definitions | map(object) | Yes      |


## Outputs

| Name              | Description                   |
| ----------------- | ----------------------------- |
| `vpc_id`          | ID of the created VPC         |
| `public_subnets`  | Map of public subnet details  |
| `private_subnets` | Map of private subnet details |


## Common Issues & Errors

### 1. Invalid CIDR Block

**Error**

```text
The cidr_block must be a valid IPv4 CIDR
```

**Cause**
Invalid CIDR format like `10.0.0.0`.

**Fix**
Use valid CIDR notation, e.g. `10.0.0.0/16`.

### 2. Availability Zone Validation Error

**Error**

```text
Each subnet az must be a valid Availability Zone
```

**Fix**
Use AZs like:

* `ap-south-1a`
* `us-east-1b`

### 3. No Internet Access from Public Subnet

**Cause**

* Subnet marked `public = false`
* Route table not associated

**Fix**
Ensure:

```hcl
public = true
```

### 4. Terraform Apply Fails with IAM Errors

**Cause**
Insufficient IAM permissions for:

* `ec2:CreateVpc`
* `ec2:CreateSubnet`
* `ec2:CreateInternetGateway`
* `ec2:CreateRouteTable`

**Fix**
Attach required IAM policies (VPC, EC2 permissions).

## Design Decisions

* Uses `for_each` instead of `count` for predictable resource addressing
* Conditional resources prevent unnecessary AWS objects
* Outputs are structured for easy consumption by other modules

## License

MIT License. See [LICENSE](LICENSE).

## Credits & References

* Terraform Module Development
  [https://developer.hashicorp.com/terraform/language/modules/develop](https://developer.hashicorp.com/terraform/language/modules/develop)

* AWS VPC Documentation
  [https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)

* Terraform AWS Provider
  [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

# Terraform AWS Backend

This Terraform project demonstrates **provisioning an EC2 instance** in AWS while using an **S3 bucket as a remote backend** for storing Terraform state (`tfstate`).  

It covers **real-world scenarios**, **common issues**, and **best practices** when working with Terraform in AWS.


## Overview

- **Terraform Version:** 1.x (AWS provider v6.26.0)  
- **AWS Region:** Your region 
- **AWS Profiles Used:** `terraform-admin`  
- **Purpose:** Learn **remote state management**, **EC2 provisioning**, and **handling Terraform issues in real AWS environments**.

## Architecture

**Explanation:**

1. Terraform code is stored locally.
2. S3 bucket acts as the **remote backend**, storing `terraform.tfstate`.
3. Terraform interacts with AWS to create EC2 resources.
4. Backend ensures **state persistence**, **collaboration**, and **auditability**.


## AWS Resources Managed

1. **S3 Backend Bucket**

   * Bucket Name: `your_s3_bucket_id`
   * Stores **remote Terraform state**.
   * Created in the previous project (`03-aws-s3`) and reused here.

2. **EC2 Instance**

   * AMI: (Amazon Linux 2 / region)
   * Instance Type: `t2.micro`
   * Tags:

     ```text
     Name = sandbox-ec2
     ```

## Terraform Configuration (`main.tf`)

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

provider "aws" {
  region  = var.region
  profile = "terraform-admin"
}

resource "aws_instance" "sandbox_ec2" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t2.micro"

  tags = {
    Name = "sandbox-ec2"
  }
}
```

---
### Backend S3 Bucket

* Created a backend bucket in **03-aws-s3** project.
* Ensured the bucket exists before initializing backend.
* Confirmed bucket is **empty or safe** for remote state.

### Terraform Initialization

* Initialized Terraform backend:

  ```bash
  terraform init
  ```
* **Issue Faced:**

  ```
  Error: No valid credential sources found
  ```

  **Cause:** Terraform backend uses AWS credentials **separately from provider**; if environment variables are unset or profile missing, backend cannot access S3.

  **Solution:**

  ```bash
  export AWS_PROFILE=terraform-admin
  terraform init
  ```

  Now Terraform backend accesses S3 using the correct profile.

### EC2 Resource Creation

* Created EC2 instance:

  ```bash
  terraform apply
  ```
* Verified creation in AWS console.

### Resource Destruction

* Destroyed EC2 instance:

  ```bash
  terraform destroy
  ```
* **Issue Faced:** Cannot delete S3 bucket if it contains objects.

  ```
  BucketNotEmpty: The bucket you tried to delete is not empty
  ```

  **Solution:** Empty the bucket manually (or via Terraform `aws_s3_bucket_object`) before deletion.

## Real-World Learnings

1. **AWS Profiles & Terraform Backend**

   * Backends use **AWS credentials separately from provider block**.
   * Always verify credentials before `terraform init` to avoid `ExpiredToken` errors.
   * When switching devices or after long inactivity, re-export the profile:

     ```bash
     export AWS_PROFILE=terraform-admin
     ```

2. **Terraform State**

   * Manual deletion of resources in AWS **does not clean `terraform.tfstate`**.
   * State drift can cause Terraform to think resources still exist.
   * Clean `.tfstate` or use `terraform import` to sync state.

3. **S3 Backend**

   * Remote state allows **collaboration** and **persistent tracking**.
   * Bucket must exist and be accessible via correct credentials.
   * Be careful not to delete backend bucket while it holds state for other projects.

4. **Sandbox Best Practices**

   * Use small instances (`t2.micro`) and temporary buckets for learning.
   * Always verify the AWS profile and region before applying changes.
   * Use random suffixes for S3 buckets to avoid conflicts in shared accounts.

## References

* [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [Terraform S3 Backend Documentation](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
* [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)

# Terraform + AWS S3

This document explains **how Terraform manages AWS S3**, the difference between **static vs dynamic bucket naming**.


## Static S3 Bucket Configuration (Basic Approach)

### Example

```hcl
resource "aws_s3_bucket" "sandbox_s3" {
  bucket = "your_given_bucket_name"
}
```

### Characteristics

- ✅ Simple
- ✅ Easy to understand
- ❌ Bucket names must be **globally unique**
- ❌ Fails if the bucket already exists
- ❌ Not suitable for automation or CI/CD

This approach is acceptable for **basic learning only**.


## Uploading Objects to S3

```hcl
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.sandbox_s3.id
  key    = "index.html"
  source = "index.html"
}
```

This uploads:

* Local `index.html`
* Into the S3 bucket as `index.html`


## Dynamic S3 Bucket Configuration (Recommended)

To avoid naming conflicts, Terraform supports **dynamic values**.

### Random Provider

```hcl
required_providers {
  random = {
    source  = "hashicorp/random"
    version = "3.7.2"
  }
}
```

### Generate Random ID

```hcl
resource "random_id" "bucket_suffix" {
  byte_length = 4
}
```

Generates a random hexadecimal string.


### Dynamic Bucket Name

```hcl
resource "aws_s3_bucket" "sandbox_s3" {
  bucket = "your_given_bucket_name-${random_id.bucket_suffix.hex}"
}
```

Example final name:

```
your_given_bucket_name-a3f91b7e
```


## Uploading File with Correct Metadata

```hcl
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.sandbox_s3.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}
```


## Why Dynamic Naming Is Best Practice

| Feature           | Static Name | Dynamic Name |
| ----------------- | ----------- | ------------ |
| Global uniqueness | ❌           | ✅            |
| CI/CD safe        | ❌           | ✅            |
| Team-friendly     | ❌           | ✅            |
| Reusable          | ❌           | ✅            |
| Production-ready  | ❌           | ✅            |

✔ **Dynamic naming is the industry standard**


## Dependency Graph (How Terraform Decides Order)

Terraform automatically builds this graph:

```
random_id
   ↓
aws_s3_bucket
   ↓
aws_s3_object
```

You never manually define execution order.


## Amazon S3 Overview

**Amazon S3 (Simple Storage Service)** is:

* Scalable
* Highly durable
* Object-based storage
* Used for backups, static websites, logs, artifacts, and data lakes

Terraform acts as:

> **The automation layer that defines and manages S3 reliably**

---

## Best Practice Recommendation

- ✅ Use **dynamic bucket names**
- ✅ Avoid hardcoding cloud constraints
- ✅ Let Terraform manage dependencies
- ✅ Prefer automation-friendly patterns early

---

## Final Insight

> **Hardcoded infrastructure works for demos.
> Parameterized infrastructure works for real cloud engineering.**
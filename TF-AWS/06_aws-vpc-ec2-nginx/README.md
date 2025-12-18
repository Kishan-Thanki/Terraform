# Terraform AWS VPC + EC2 (Nginx) Sandbox

This demonstrates building a **basic AWS network and compute stack using Terraform**, starting from a clean AWS account and ending with a **publicly accessible Nginx server** running on EC2.

The goal of this repository is **learning by doing** — understanding *how AWS networking really works*, and *how Terraform maps to AWS primitives*.


## Architecture Overview

**Region:** `ap-south-1 (Mumbai)`
**Availability Zone:** `ap-south-1a`

### Components Created

* Custom VPC (`10.0.0.0/16`)
* Public Subnet (`10.0.2.0/24`)
* Private Subnet (`10.0.1.0/24`)
* Internet Gateway (IGW)
* Public Route Table
* EC2 Instance (Ubuntu 24.04 + Nginx)
* Security Group (HTTP access)
* Terraform Outputs (Public IP & URL)

### High-Level Flow

```
Internet
   |
Internet Gateway
   |
Public Route Table (0.0.0.0/0)
   |
Public Subnet (ap-south-1a)
   |
EC2 (Nginx)
```

## Terraform File Structure

```
.
├── main.tf               # Terraform & AWS provider configuration
├── vpc.tf                # VPC, subnets, IGW, route tables
├── ec2.tf                # EC2 instance + user_data
├── security_groups.tf    # Security group rules
└── outputs.tf            # Public IP and URL outputs
```


## What This Project Does

* Creates a **custom VPC** instead of using the default VPC
* Explicitly defines a **public subnet** with internet access
* Launches an **EC2 instance** with:

  * Public IP
  * Ubuntu AMI
  * Nginx installed automatically using `user_data`
* Exposes Nginx on **port 80** to the public internet
* Outputs a **ready-to-use URL** after `terraform apply`


## Problems Faced & Lessons Learned (Very Important)

This section documents *real issues* encountered and how they were solved.


### 1️⃣ “Site Refused to Connect” (ERR_CONNECTION_REFUSED)

**Cause**

* EC2 was running, but:

  * No public route existed
  * OR no public IP was assigned
  * OR Security Group didn’t allow port 80

**Fix**

* Added Internet Gateway
* Added route `0.0.0.0/0 → IGW`
* Associated route table with public subnet
* Enabled:

  ```hcl
  map_public_ip_on_launch = true
  ```
* Allowed inbound HTTP (80) in Security Group

---

### 2️⃣ Subnet vs VPC ID Confusion

**Mistake**

```hcl
subnet_id = aws_vpc.sandbox_vpc.id
```

**Why it Failed**

* EC2 expects a **Subnet ID**, not a VPC ID

**Fix**

```hcl
subnet_id = aws_subnet.public_subnet.id
```

---

### 3️⃣ AMI OS vs Package Manager Mismatch

**What Happened**

* Used Ubuntu AMI
* Ran `dnf install nginx` (Amazon Linux command)

**Result**

* Nginx never installed
* Instance appeared healthy but refused connections

**Fix**
Ubuntu requires `apt`:

```bash
apt update -y
apt install -y nginx
```

---

### 4️⃣ Instance Type Not Supported in AZ

**Error**

```
t2.micro is not supported in ap-south-1c
```

**Why**

* Some instance types are **not available in all AZs**

**Fix**

* Pinned subnets to `ap-south-1a`
* OR allowed AWS to auto-select AZ

---

### 5️⃣ Free Tier Confusion (Old vs New)

**Reality**

* Older accounts → `t2.micro` (legacy)
* Newer free plans → `t3.micro`, `t4g.micro`
* Console messaging can be misleading

**Decision**

* Used `t3.micro` (safe + supported + within credits)


## Final Working Configuration

### EC2 Instance

* Ubuntu 24.04 LTS
* `t3.micro`
* Public IP
* Nginx auto-installed

### Access

After `terraform apply`, Terraform outputs:

```
instance_public_ip = x.x.x.x
instance_url       = http://x.x.x.x
```

Open the URL in your browser → **Nginx Welcome Page**


## How to Run

```bash
terraform init
terraform plan
terraform apply
```

To clean up:

```bash
terraform destroy
```

---

## Key Takeaways

* AWS networking is **route-based**, not magic
* Public subnet ≠ public unless routed
* AMI choice dictates OS behavior
* AZs matter more than most tutorials admit


## Why This Matters

This reflects **real-world DevOps debugging**.

Every failure taught something fundamental about AWS.

We should understand *why this works*.
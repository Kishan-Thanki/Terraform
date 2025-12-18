# Terraform AWS VPC + EC2 (Nginx) Sandbox 🚀

![AWS](https://img.shields.io/badge/AWS-VPC%20%7C%20EC2-orange?logo=amazonaws)
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple?logo=terraform)
![Status](https://img.shields.io/badge/Status-Learning%20Sandbox-green)

This repository demonstrates building a **basic AWS network and compute stack using Terraform**, starting from a **clean AWS account** and ending with a **publicly accessible Nginx server** running on Amazon EC2.

The primary goal is **learning by doing** — deeply understanding:

- How **AWS networking actually works**
- How **Terraform maps declarative code to AWS primitives**
- How to debug **real-world cloud issues**, not just happy paths

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [High-Level Network Flow](#high-level-network-flow)
3. [Terraform File Structure](#terraform-file-structure)
4. [What This Project Does](#what-this-project-does)
5. [Problems Faced & Lessons Learned](#problems-faced--lessons-learned)
6. [Final Working Configuration](#final-working-configuration)
7. [Key Takeaways](#key-takeaways)
8. [Why This Matters](#why-this-matters)
9. [References & Credits](#references--credits)


## Architecture Overview

**Region:** `ap-south-1 (Mumbai)`  
**Availability Zone:** `ap-south-1a`

### AWS Resources Created

- Custom **VPC** (`10.0.0.0/16`)
- **Public Subnet** (`10.0.2.0/24`)
- **Private Subnet** (`10.0.1.0/24`)
- **Internet Gateway (IGW)**
- **Public Route Table**
- **EC2 Instance** (Ubuntu 24.04 LTS + Nginx)
- **Security Group** (HTTP access on port 80)
- **Terraform Outputs** (Public IP & URL)

## High-Level Network Flow

```text
            Internet
                |
        [ Internet Gateway ]
                |
     [ Public Route Table ]
        (0.0.0.0/0 → IGW)
                |
        [ Public Subnet ]
        (ap-south-1a)
                |
          EC2 Instance
            (Nginx)
````

### Important Insight

> A subnet is **not public by default**.
> It becomes public **only when its route table points to an Internet Gateway**.

## Terraform File Structure

```text
.
├── main.tf               # Terraform & AWS provider configuration
├── vpc.tf                # VPC, subnets, IGW, route tables
├── ec2.tf                # EC2 instance + user_data
├── security_groups.tf    # Security group rules
└── outputs.tf            # Public IP and URL outputs
```

Terraform automatically loads all `.tf` files and builds a dependency graph.

Terraform reference:
[https://developer.hashicorp.com/terraform/language/files](https://developer.hashicorp.com/terraform/language/files)


## What This Project Does

✔ Creates a **custom VPC** (no default VPC dependency)
✔ Explicitly defines a **public subnet with internet access**
✔ Launches an **EC2 instance** with:

* Public IP
* Ubuntu 24.04 AMI
* Nginx auto-installed via `user_data`
  ✔ Exposes Nginx on **port 80**
  ✔ Outputs a **ready-to-use public URL**

This project intentionally avoids abstractions to show **raw AWS behavior**.

## Problems Faced & Lessons Learned (Very Important)

This section documents **real-world issues** encountered during development.

### ERR_CONNECTION_REFUSED (Site Refused to Connect)

#### Cause

The EC2 instance was running, but one or more of the following were missing:

* ❌ No Internet Gateway
* ❌ No `0.0.0.0/0` route
* ❌ No public IP
* ❌ Security Group didn’t allow port 80

#### Fix

* Added Internet Gateway
* Added route: `0.0.0.0/0 → IGW`
* Associated route table with public subnet
* Enabled public IP assignment:

```hcl
map_public_ip_on_launch = true
```

* Allowed inbound HTTP (80) in Security Group

AWS reference:
[https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)

### Subnet ID vs VPC ID Confusion

#### Mistake

```hcl
subnet_id = aws_vpc.sandbox_vpc.id
```

#### Why It Failed

* EC2 **must be launched inside a subnet**
* VPC ID ≠ Subnet ID

#### Fix

```hcl
subnet_id = aws_subnet.public_subnet.id
```

AWS EC2 reference:
[https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-vpc.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-vpc.html)

### AMI OS vs Package Manager Mismatch

#### What Happened

* Ubuntu AMI was used
* Amazon Linux command executed:

```bash
dnf install nginx
```

#### Result

* Nginx never installed
* EC2 was healthy but port 80 refused connections

#### Fix (Ubuntu)

```bash
apt update -y
apt install -y nginx
```

Ubuntu on AWS:
[https://ubuntu.com/aws](https://ubuntu.com/aws)

### Instance Type Not Supported in AZ

#### Error

```text
t2.micro is not supported in ap-south-1c
```

#### Why

* Instance availability varies by Availability Zone

#### Fix

* Explicitly pinned subnets to `ap-south-1a`
* Or let AWS auto-select the AZ

AWS AZ documentation:
[https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)

## Final Working Configuration

### EC2 Instance

* Ubuntu 24.04 LTS
* `t3.micro`
* Public IP assigned
* Nginx auto-installed via `user_data`

### Access

After `terraform apply`:

```text
instance_public_ip = x.x.x.x
instance_url       = http://x.x.x.x
```

Opening the URL shows the **Nginx Welcome Page**.

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

Terraform CLI:
[https://developer.hashicorp.com/terraform/cli](https://developer.hashicorp.com/terraform/cli)

## Key Takeaways

* AWS networking is **route-based**, not automatic
* Public subnet ≠ public unless routed
* AMI choice determines OS behavior
* Availability Zones matter
* Terraform exposes mistakes early — if you read the errors


## Why This Matters

This project mirrors **real-world DevOps debugging**.

Every failure revealed a **core AWS concept**:

* Networking
* Routing
* OS behavior
* Availability constraints

> We don’t learn cloud by copying diagrams —
> we learn it by breaking things and fixing them intentionally.

## References & Credits

### Official AWS Documentation

* Amazon VPC
  [https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
* EC2 User Guide
  [https://docs.aws.amazon.com/ec2/](https://docs.aws.amazon.com/ec2/)
* Security Groups
  [https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)
* Internet Gateway
  [https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)
* AWS Free Tier
  [https://aws.amazon.com/free/](https://aws.amazon.com/free/)

### Terraform Documentation

* AWS Provider
  [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* Terraform Language
  [https://developer.hashicorp.com/terraform/language](https://developer.hashicorp.com/terraform/language)
* Provisioning with Terraform
  [https://developer.hashicorp.com/terraform/tutorials/aws-get-started](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)


### Credits & Disclaimer

* AWS®, Amazon EC2®, and Amazon VPC® are trademarks of **Amazon Web Services, Inc.**
* Terraform® is a trademark of **HashiCorp**
* This project is for **educational and learning purposes only**

**License**
MIT / Educational Use
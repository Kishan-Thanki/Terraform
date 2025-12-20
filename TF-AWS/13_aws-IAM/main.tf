terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "terraform-admin"
}

############################
# Load YAML users
############################
locals {
  users_data = yamldecode(file("${path.module}/users.yaml")).users

  # Flatten user → policy mapping
  user_policy_pairs = flatten([
    for user in local.users_data : [
      for policy in user.policies : {
        username = user.username
        policy   = policy
      }
    ]
  ])
}

############################
# IAM Users
############################
resource "aws_iam_user" "users" {
  for_each = {
    for user in local.users_data :
    user.username => user
  }

  name = each.key
}

############################
# IAM Policy Attachments
############################
resource "aws_iam_user_policy_attachment" "policy_attach" {
  for_each = {
    for pair in local.user_policy_pairs :
    "${pair.username}-${pair.policy}" => pair
  }

  user       = each.value.username
  policy_arn = "arn:aws:iam::aws:policy/${each.value.policy}"
}

############################
# Login Profiles
############################
resource "aws_iam_user_login_profile" "profile" {
  for_each        = aws_iam_user.users
  user            = each.value.name
  password_length = 12
}

############################
# Outputs
############################
output "iam_users" {
  value = keys(aws_iam_user.users)
}
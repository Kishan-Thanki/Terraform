terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "terraform-admin"
}

# Generate a random ID for uniqueness
resource "random_id" "bucket_id" {
  byte_length = 8
}

# Create the S3 bucket
resource "aws_s3_bucket" "sandbox_s3" {
  bucket = "sandbox-terraform-s3-ap-south-1-${random_id.bucket_id.hex}"
}

# Block public access settings (override to allow website)
resource "aws_s3_bucket_public_access_block" "sandbox_s3_block" {
  bucket = aws_s3_bucket.sandbox_s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configure S3 bucket as a static website
resource "aws_s3_bucket_website_configuration" "sandbox_s3_website" {
  bucket = aws_s3_bucket.sandbox_s3.id

  index_document {
    suffix = "index.html"
  }
}

# Upload index.html to the bucket
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.sandbox_s3.id
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
}

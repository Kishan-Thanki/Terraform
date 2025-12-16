output "sandbox_s3_bucket_name" {
  value       = aws_s3_bucket.sandbox_s3.bucket
  description = "The name of the S3 bucket created for sandbox purposes"
}

output "sandbox_s3_website_url" {
  value       = aws_s3_bucket_website_configuration.sandbox_s3_website.website_endpoint
  description = "The public URL of the S3 static website"
}

output "bucket_name"{
    description = "Bucket name for our static website hosting"
    value = module.cloud_resume.bucket_name
}

output "s3_website_endpoint" {
  description = "S3 Static Website hosting endpoint"
  value = module.cloud_resume.website_endpoint
}

output "cloudfront_url"{
  description = "CloudFront Distribution Domain Name"
  value = module.cloud_resume.cloudfront_url
}
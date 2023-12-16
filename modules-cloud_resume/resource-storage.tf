locals {
  content_type_map = {
    "css" = "text/css"
    "eot" = "application/vnd.ms-fontobject"
    "js" = "text/javascript"
    "jpg" = "image/jpeg"
    "png" = "image/png"
    "scss" = "text/css"
    "svg" = "image/svg+xml"
    "ttf" = "font/ttf"
    "woff" = "font/woff"
    "woff2" = "font/woff2"    
  }
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "project"
    Environment = "cloud-resume"
  }
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "./public/index.html"
  content_type = "text/html"
    etag = filemd5("./public/index.html")
   lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
   }
}

resource "aws_s3_object" "upload_assets" {
  for_each = fileset("./public/","**")
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = each.key
  source = "./public/${each.value}"
  content_type = lookup(local.content_type_map, split(".","${each.value}")[1],"text/html")
  etag = filemd5("./public/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.bucket
  # policy = data.aws_iam_policy_document.allow_access_from_another_account.json
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
            "Sid" = "AllowCloudFrontServicePrincipalReadOnly",
            "Effect" = "Allow",
            "Principal" = {
                "Service" = "cloudfront.amazonaws.com"
            },
            "Action" = "s3:GetObject",
            "Resource" = "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
            "Condition" = {
                "StringEquals" = {
                    #"AWS:SourceArn" : data.aws_caller_identity.current.arn
                   "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
                }
            }
        }

  })
}


resource "terraform_data" "content_version" {
  input = var.content_version
}
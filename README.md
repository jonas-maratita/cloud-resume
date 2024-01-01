# Cloud Resume

This is my take on the cloud resume challenge. I did use a template for the html and css.

The template for my resume was provided by [html5up.net](https://html5up.net/)

I have a conversant level of understanding for html and css. A majority of everything I have learned so far has<br>
been through courses I've taken online offered through [Coursera](https://www.coursera.org/). I began this journey after I attended<br>
a bootcamp offered by [Intellectual Point](https://intellectualpoint.com/) where I obtained the AWS SAA certifcate and CompTia Sec+ Certificate.

## Terraform
I attended Andrew Brown's Terraform beginner bootcamp. The Terraform code used here is derived from code that was used during the bootcamp.

I did struggle with uploading the asset directory and subdirectories to S3. The content types for each file was uploading as application/octet instead of text/html or whatever content type was required for the object. My brother assisted greatly in helping to refactor the code as shown below to upload to S3.

```tf
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
```
[Back To Top](#cloud-resume)

### Adding Blog to Cloud Resume

I created an A record in Route53 to point to blog.maratita.link. The blog is hosted by Hashnode.

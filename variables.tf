variable "bucket_name" {
 type = string
}

variable "index_html_filepath" {
  type = string
}

variable "content_version" {
  type        = number
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate"
  type = string
}

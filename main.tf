terraform {

}

module "cloud_resume" {
  source = "./modules-cloud_resume"
  bucket_name = var.bucket_name
  index_html_filepath = var.index_html_filepath
  content_version = var.content_version
  }



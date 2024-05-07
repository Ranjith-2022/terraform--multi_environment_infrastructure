terraform {
  backend "s3" {
    bucket = "terraform-project-12"         // Bucket where to SAVE Terraform State
    key    = "staging-webserver/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                        // Region where bucket is created
  }
}
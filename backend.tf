terraform {
  backend "s3" {
    bucket = "krishnateja-sample-terraform-state-bucket-for-testing"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"
  }
}



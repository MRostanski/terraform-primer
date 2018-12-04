
provider "aws" {
  version = "~> 1.0"
  region = "${var.region}"
}


terraform {
  backend "s3" {
    bucket         = "terraform-bucket-20181204203630663000000001"
    key            = "sodo"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock-sodo"
  }
}
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Product     = "hlm"
      Environment = "certi"
      Project     = "hollywood"
      Owner       = "lamark"
    }
  }
}

terraform {
  #
  # backend "s3" {}
  backend "s3" {
    bucket = "lamark.infrastructure.prod"
    key    = "terraform/infrastructure/eks/terraform.state"
    region = "us-east-1"
  }
  required_version = ">= 0.12.0"
}
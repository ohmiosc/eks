
provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
    backend "s3" {
    bucket = "lamark.infrastructure.prod"
    key    = "terraform/infrastructure/eks-certi/terraform.state"
    region = "us-east-1"
  }

  required_version = "~> 1.0"
}

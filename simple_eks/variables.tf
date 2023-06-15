variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  # description = "Name of the project deployment."
  type    = string
  default = "test_lamark"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "TerraformEKS"
    "Environment" = "Development"
    "Owner"       = "Lamark"
  }
}

variable "vpc_id" {
  default     = "vpc-0b5047bc48612be61"
  type        = string
  description = "Id Vpc"
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default = [
    {
      name    = "kube-proxy"
      version = "v1.26.4-eksbuild.1"
    },
    {
      name    = "vpc-cni"
      version = "v1.12.6-eksbuild.2"
    },
    {
      name    = "coredns"
      version = "v1.9.3-eksbuild.3"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.19.0-eksbuild.2"
    }
  ]
}
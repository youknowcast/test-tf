variable "profile" {
  type    = string
  default = ""
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">=1.0.0"
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = var.profile
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.0"
    }
  }

  backend "s3" {
    bucket = "haya10-tfstate-bucket-h2af"
    key    = "terraform/terraform.tfstate"
    region = "ap-northeast-1"
    profile = "terraform"
    encrypt = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
  profile = "terraform"
}

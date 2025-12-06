terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.0"
    }
  }

  backend "local" {
    path = "./scratch_state/terraform.tfstate"
  }
}

provider "aws" {
  region = "ap-northeast-1"
  profile = "terraform"
}

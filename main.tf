terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.2"

  backend "s3" {
    bucket = "terraformbucket325"
    key    = "3TierProject//terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region  = "us-west-2"
}


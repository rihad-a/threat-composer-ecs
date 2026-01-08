terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }
  }
  backend "s3" {
  bucket = "rihads3"
  key = "terraform.tfstate"
  region = "eu-west-2"
  use_lockfile = false
  encrypt = true
 }
}

provider "aws" {
  region = "eu-west-2"
  # Configuration options
}

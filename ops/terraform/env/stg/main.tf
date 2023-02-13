terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket  = "pfm-terraform-backend-bucket"
    region  = "us-east-1"
    key     = "staging/terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.68"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.0"
    }
  } 
}

provider "aws" {
  region = var.aws_region
}

module "aws-remote-state" {
  source = "../modules/aws-remote-state"

  # Bucket
  bucket_enc_key_deletion_in_days = 10
  bucket_enc_key_rotation_enabled = true
  bucket_enc_key_alias = "alias/pfm-terraform-backend-bucket-key"
  bucket_name = "pfm-terraform-backend-bucket"
  acl = "private"

  # Lock
  dynamodb_table_name = "pfm-terraform-state"
  dynamodb_table_read_capacity = 20
  dynamodb_table_write_capacity = 20
}
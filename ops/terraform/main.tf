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

  backend "s3" {
    bucket = "insights-terraform-backend-bucket"
    key    = "periculum-pdf-parser/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  resource_name_prefix = "prod-pdf-parser"
  rds_username = "masteruser"
  rds_secret_string_pdf_processing_integration = {
    username = local.rds_username
    password = random_password.rds_password_pdf_processing.result
  }
  pdf_processing_api_credentials_secret = {
    s3_bucket_name = "${local.resource_name_prefix}-${var.bucket_names[0]}"
    sqs_url = aws_sqs_queue.sqs_queue_pdf_processing.url
    database_connection_string = aws_db_instance.db_instance_pdf_processing.address
    database_username = local.rds_secret_string_pdf_processing_integration.username
    database_password = local.rds_secret_string_pdf_processing_integration.password
  }
  github_info = jsondecode(data.aws_secretsmanager_secret_version.vm_github_personal_access_token_secret_version.secret_string)
  template_file_vars = {
    access_key = aws_iam_access_key.iam_access_key.id
    access_key_secret = aws_iam_access_key.iam_access_key.secret
    github_username = local.github_info.username
    github_personal_access_token = local.github_info.personal_access_token
    secret_name = aws_secretsmanager_secret.pdf_processing_api_secret.name
  }
  public_subnet_ids = [for s in data.aws_subnet.insights_public_subnet : s.id]
}
data "aws_secretsmanager_secret" "vm_github_personal_access_token_secret" {
  arn = var.secrets_manager_vm_github_personal_access_token_arn
}

resource "aws_secretsmanager_secret" "pfm_api_secret" {
  name = "pfm/prod/api"
}

resource "aws_secretsmanager_secret" "db_credentials_secret" {
  name = "pfm/prod/rds"
}

resource "aws_secretsmanager_secret_version" "pfm_api_secret_version" {
  secret_id = aws_secretsmanager_secret.pfm_api_secret.id
  secret_string = jsonencode(local.pdf_processing_api_credentials_secret)
}

resource "aws_secretsmanager_secret_version" "db_credentials_secret_version" {
  secret_id = aws_secretsmanager_secret.db_credentials_secret.id
  secret_string = jsonencode(local.rds_secret_string_pfm_integration)
}

data "aws_secretsmanager_secret_version" "vm_github_personal_access_token_secret_version" {
  secret_id = data.aws_secretsmanager_secret.vm_github_personal_access_token_secret.id
}
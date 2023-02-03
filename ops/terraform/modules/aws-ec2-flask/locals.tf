locals {
  environment = var.environment
  resource_name_prefix = var.resource_name_prefix
  common_tags = {
    environment = local.environment
  }
  template_file_vars = {
    access_key = aws_iam_access_key.iam_access_key.id
    access_key_secret = aws_iam_access_key.iam_access_key.secret
    github_username = local.github_info.username
    github_personal_access_token = local.github_info.personal_access_token
    secret_name = aws_secretsmanager_secret.pfm_admin_api_secret.name
  }
  public_subnet_ids = [for s in data.aws_subnet.ec2_public_subnet : s.id]
  pfm_api_credentials_secret = {
    s3_bucket_name = "${local.resource_name_prefix}-${var.bucket_names[0]}"
    database_connection_string = aws_db_instance.db_instance.address
    database_username = local.rds_secret_string_pfm_integration.username
    database_password = local.rds_secret_string_pfm_integration.password
  }
  rds_secret_string_pfm_integration = {
    username = var.rds_username
    password = random_password.rds_password.result
  }
  github_info = jsondecode(data.aws_secretsmanager_secret_version.vm_github_personal_access_token_secret_version.secret_string)
}
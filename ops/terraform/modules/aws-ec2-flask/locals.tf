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
  public_subnet_ids = [for s in data.aws_subnet.pfm_public_subnet : s.id]
}
resource "random_password" "keycloak_admin_password" {
  length           = 24
  special          = true
  override_special = "_!%^"
}

data "aws_secretsmanager_secret" "github_psa_secret" {
  arn = var.github_secret_arn
}

data "aws_secretsmanager_secret_version" "github_psa_secret_version" {
  secret_id = data.aws_secretsmanager_secret.github_psa_secret.id
}

locals {
  github_info = jsondecode(data.aws_secretsmanager_secret_version.github_psa_secret_version.secret_string)
  ec2_user_data_variables = {
    host_name                     = var.public_dns_name
    keycloak_admin_name           = "admin"
    keycloak_admin_password       = random_password.keycloak_admin_password.result
    database_hostname             = aws_db_instance.keycloakdb.address
    database_port                 = aws_db_instance.keycloakdb.port
    database_name                 = var.database_name
    database_username             = var.database_username
    database_password             = random_password.rds_password.result
    github_username               = local.github_info.username
    github_personal_access_token  = local.github_info.personal_access_token
  }
}
# locals {
#   #rds_username = "masteruser"
#   #rds_secret_string_pfm_integration = {
#   #  username = local.rds_username
#   #  password = random_password.rds_password.result
#   #}
#   pfm_api_credentials_secret = {
#   #   s3_bucket_name = "${local.resource_name_prefix}-${var.bucket_names[0]}"
#   #   database_connection_string = aws_db_instance.db_instance_pfm.address
#   #   database_username = local.rds_secret_string_pfm_integration.username
#   #   database_password = local.rds_secret_string_pfm_integration.password
#   }
#   github_info = jsondecode(data.aws_secretsmanager_secret_version.vm_github_personal_access_token_secret_version.secret_string)
# }

# data "aws_secretsmanager_secret" "vm_github_personal_access_token_secret" {
#   arn = var.secrets_manager_vm_github_personal_access_token_arn
# }

# data "aws_secretsmanager_secret_version" "vm_github_personal_access_token_secret_version" {
#   secret_id = data.aws_secretsmanager_secret.vm_github_personal_access_token_secret.id
# }

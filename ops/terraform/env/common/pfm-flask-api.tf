module "pfm_flask_api" {
  source = "../../modules/aws-ec2-flask"

  environment          = local.environment
  resource_name_prefix = local.resource_name_prefix
  
  aws_region           = var.aws_region

  vpc_id               = var.vpc_id
  vpc_public_subnets   = var.vpc_pfm_public_subnets

  ec2_ami_id           = var.ec2_ami_id
  ec2_instance_type    = var.ec2_instance_type

  ec2_insights_private_subnet_us_east_1a  = var.ec2_insights_private_subnet_us_east_1a
  ec2_ssh_private_key_secret_name         = var.ec2_ssh_private_key_secret_name
  ec2_ssh_public_key_secret_name          = var.ec2_ssh_public_key_secret_name
  ec2_lb_domain_name                      = var.ec2_lb_domain_name
  ec2_keycloak_authority                  = var.ec2_keycloak_authority

  bucket_names                    = var.bucket_names

  rds_username                    = var.rds_username
  rds_allocated_storage           = var.rds_allocated_storage
  rds_max_allocated_storage       = var.rds_max_allocated_storage
  rds_instance_class              = var.rds_instance_class
  rds_multi_az_enabled            = var.rds_multi_az_enabled
  rds_availability_zone           = var.rds_availability_zone
  rds_backup_retention_period     = var.rds_backup_retention_period  
  rds_allow_minor_version_upgrade = var.rds_allow_minor_version_upgrade
  rds_cloudwatch_logs_exports     = var.rds_cloudwatch_logs_exports
  rds_deletion_protection         = true
  rds_kms_key_alias_names         = var.rds_kms_key_alias_names_pfm
  
  aws_db_subnet_group             = var.pfm_aws_db_subnet_group

  secrets_manager_vm_github_personal_access_token_arn = var.secrets_manager_vm_github_personal_access_token_arn

  alb_security_group_id           = module.aws_infrastructure.aws_alb_security_group_id

  depends_on = [
    module.aws_infrastructure
  ]
}

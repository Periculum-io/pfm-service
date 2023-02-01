module "pfm_flask_api" {
  source = "../../modules/pfm-flask-infrastructure"

  aws_region = var.aws_region

  ec2_ami_id = var.ec2_ami_id
  ec2_instance_type = var.ec2_instance_type  
  
  vpc_id = var.vpc
  vpc_pfm_public_subnets = var.vpc_pfm_public_subnets
  ec2_prod_insights_private_subnet_us_east_1a = var.ec2_prod_insights_private_subnet_us_east_1a
  ec2_ssh_private_key_secret_name = var.ec2_ssh_private_key_secret_name
  ec2_ssh_public_key_secret_name = var.ec2_ssh_public_key_secret_name

  bucket_names = var.bucket_names
}

module "rds" {
  source = "../../modules/aws-rds"

  environment = var.environment
  vpc_id      = var.vpc_id

  rds_allocated_storage         = var.rds_allocated_storage
  rds_max_allocated_storage     = var.rds_max_allocated_storage
  rds_instance_class            = var.rds_instance_class
  rds_multi_az_enabled          = var.rds_multi_az_enabled
  rds_availability_zone         = var.rds_availability_zone
  rds_backup_retention_period   = var.rds_backup_retention_period
  rds_deletion_protection       = var.rds_deletion_protection
  rds_delete_backups            = var.rds_delete_backups
  rds_skip_final_snapshot       = var.rds_skip_final_snapshot
 
}
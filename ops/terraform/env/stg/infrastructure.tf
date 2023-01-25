module "aws_infrastructure" {
  source = "../../modules/aws-infrastructure-common"

  aws_region         = var.aws_region
  environment        = var.environment
  availability_zones = var.availability_zones

  vpc_public_subnets_cidr  = var.vpc_public_subnets_cidr
  vpc_private_subnets_cidr = var.vpc_private_subnets_cidr

  ecs_cluster_name               = var.ecs_cluster_name
  ecs_cluster_capacity_providers = var.ecs_cluster_capacity_providers
  ecs_container_insights_enabled = var.ecs_container_insights_enabled

  alb_log_enabled   = var.alb_log_enabled
  alb_log_prefix    = var.alb_log_prefix
  alb_s3_bucket_acl = var.alb_s3_bucket_acl
  r53_hosted_zone_id   = var.r53_hosted_zone_id
  r53_target_domain = var.r53_target_domain

  buckets_count = var.s3_buckets_count
  bucket_names  = var.s3_bucket_names
}

module "rds" {
  source = "../../modules/aws-rds"

  environment = var.environment
  vpc_id      = module.aws_infrastructure.vpc_id

  rds_allocated_storage         = var.rds_allocated_storage
  rds_max_allocated_storage     = var.rds_max_allocated_storage
  rds_instance_class            = var.rds_instance_class
  rds_multi_az_enabled          = var.rds_multi_az_enabled
  rds_availability_zone         = var.rds_availability_zone
  rds_backup_retention_period   = var.rds_backup_retention_period
  rds_deletion_protection       = var.rds_deletion_protection
  rds_delete_backups            = var.rds_delete_backups
  rds_skip_final_snapshot       = var.rds_skip_final_snapshot

  secret_name                   = var.rds_secret_name

  rds_subnet_ids                = module.aws_infrastructure.subnet_private_ids
  rds_source_security_group_ids = [module.pfm_api.security_group_id]
}

module "api_gateway" {
  source = "../../modules/aws-api-gateway"

  aws_region                         = var.aws_region
  environment                        = var.environment
  vpc_id                             = module.aws_infrastructure.vpc_id
  private_subnet_ids                 = module.aws_infrastructure.subnet_private_ids
  source_security_groups             = [module.pfm_api.security_group_id]
}
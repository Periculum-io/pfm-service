module "aws_infrastructure" {
  source = "../../modules/aws-infrastructure-common"

  vpc_id = var.vpc_id
  vpc_pfm_public_subnets  = var.vpc_pfm_public_subnets
  aws_region              = var.aws_region
  environment             = var.environment
  resource_name_prefix    = var.resource_name_prefix
  
  ecs_cluster_name               = var.ecs_cluster_name
  ecs_cluster_capacity_providers = var.ecs_cluster_capacity_providers
  ecs_container_insights_enabled = var.ecs_container_insights_enabled

  alb_s3_bucket_id  = var.alb_s3_bucket_id
  alb_log_enabled   = var.alb_log_enabled
  alb_log_prefix    = var.alb_log_prefix
  alb_s3_bucket_acl = var.alb_s3_bucket_acl
  
  r53_hosted_zone_id                   = var.r53_hosted_zone_id
  r53_hosted_zone_name                 = var.r53_hosted_zone_name
  r53_target_domain_pfm_admin_api      = var.r53_target_domain_pfm_admin_api
  r53_target_domain_pfm_admin_frontend = var.r53_target_domain_pfm_admin_frontend
  r53_target_domain_pfm_flask_api      = var.r53_target_domain_pfm_flask_api
}

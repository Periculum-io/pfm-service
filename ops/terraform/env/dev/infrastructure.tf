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
  r53_record_a_domain_pfm_admin_api = var.r53_target_domain_pfm_admin_api
  r53_record_a_domain_pfm_admin_frontend = var.r53_target_domain_pfm_admin_frontend
}

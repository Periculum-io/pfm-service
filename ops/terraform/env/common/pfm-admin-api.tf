locals {
  pfm_admin_api_env_variables = []
}

module "pfm_admin_api" {

  service_name = "pfm-admin-api"
  environment  = var.environment

  aws_region   = var.aws_region
  vpc_id       = module.aws_infrastructure.vpc_id
  subnet_ids   = module.aws_infrastructure.subnet_private_ids
  aws_cloudwatch_logs_group = module.aws_infrastructure.cloudwatch_log_group_name

  ecs_cluster_id               = module.aws_infrastructure.ecs_cluster_id
  alb_logs_enabled             = true
  alb_logs_bucket_id           = module.aws_infrastructure.logs_s3_bucket_alb_id
  alb_logs_prefix              = "alb-pfm-admin-api"
  source_security_group_alb_id = module.aws_infrastructure.alb_security_group_id
  security_group_alb_from_port = var.pfm_admin_api_container_port
  security_group_alb_to_port   = var.pfm_admin_api_container_port

  task_environment_variables = local.pfm_admin_api_env_variables
  task_cpu_units             = var.pfm_admin_api_cpu_units
  task_ram_units             = var.pfm_admin_api_ram_units
  secrets_manager_arn        = var.pfm_admin_api_secret_manager_arn
  sensitive_secrets_arn      = var.pfm_admin_api_sensitive_secret_arn

  container_image     = var.pfm_admin_api_ecr_url
  container_tag       = var.pfm_admin_api_version
  container_port      = var.pfm_admin_api_container_port
  container_host_port = var.pfm_admin_api_container_host_port

  ecs_service_task_count = var.pfm_admin_api_task_count

  depends_on = [module.aws_infrastructure]
}
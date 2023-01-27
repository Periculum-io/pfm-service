locals {
  frontend_env_variables = [
    {
      "name" : "REACT_APP_API_BASE_URL",
      "value" : var.frontend_base_url
    }
  ]
}
module "frontend" {
  source = "../../modules/insights-service"
  
  service_name = "frontend"
  environment  = var.environment

  aws_region                = var.aws_region
  vpc_id                    = data.aws_vpc.insights_vpc.id
  subnet_ids                = var.ec2_dev_insights_private_subnets_us_east_1
  aws_cloudwatch_logs_group = module.aws_infrastructure.cloudwatch_log_group_name

  ecs_cluster_id               = module.aws_infrastructure.ecs_cluster_id
  alb_logs_enabled             = true
  alb_logs_bucket_id           = module.aws_infrastructure.logs_s3_bucket_alb_id
  alb_logs_prefix              = "alb-frontend"
  source_security_group_alb_id = module.aws_infrastructure.alb_security_group_id
  security_group_alb_from_port = var.frontend_container_port
  security_group_alb_to_port   = var.frontend_container_port

  task_environment_variables = local.frontend_env_variables
  task_cpu_units             = var.frontend_cpu_units
  task_ram_units             = var.frontend_ram_units

  container_image     = var.frontend_ecr_url
  container_tag       = var.frontend_version
  container_port      = var.frontend_container_port
  container_host_port = var.frontend_container_host_port

  ecs_service_task_count = var.frontend_task_count

  depends_on = [module.aws_infrastructure]
}